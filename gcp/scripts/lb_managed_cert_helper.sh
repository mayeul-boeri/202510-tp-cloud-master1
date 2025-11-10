#!/usr/bin/env bash
# Helper: print DNS records, optionally create them in Cloud DNS, and poll managed certificate status
# Usage: ./lb_managed_cert_helper.sh [--zone ZONE] [--create-records] [domain...]
#   --zone ZONE         : (optional) Cloud DNS managed zone name to create A records in
#   --create-records    : if provided, the script will attempt to create A records in the specified zone using gcloud
#   domain...           : optional list of domains to use instead of reading terraform outputs
set -euo pipefail
cd "$(dirname "$0")/.."

# parse args
ZONE=""
CREATE_RECORDS=0
DOMAINS_ARG=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --zone)
      ZONE="$2"
      shift 2
      ;;
    --create-records)
      CREATE_RECORDS=1
      shift
      ;;
    --help)
      sed -n '1,80p' "$0"
      exit 0
      ;;
    *)
      DOMAINS_ARG="$DOMAINS_ARG $1"
      shift
      ;;
  esac
done

# read terraform outputs if present
if ! command -v terraform >/dev/null 2>&1; then
  echo "terraform CLI not found in PATH; the script can still create DNS via gcloud if you pass --zone and domains as args"
fi
json=$(terraform output -json 2>/dev/null || true)
if [ -z "$json" ]; then
  echo "No terraform outputs found. You can pass domains as arguments to this script."
fi

ip=$(echo "$json" | jq -r '.load_balancer_ip.value // empty' 2>/dev/null || true)
cert_link=$(echo "$json" | jq -r '.load_balancer_managed_cert.value // empty' 2>/dev/null || true)

# domains: prefer CLI args, else attempt to read from managed cert output (noting that managed cert output may be empty)
if [ -n "$(echo "$DOMAINS_ARG" | xargs)" ]; then
  domains=$(echo "$DOMAINS_ARG" | xargs)
else
  # `managed_certificate_domains` may not be available; allow the user to pass domains
  domains=$(echo "$json" | jq -r '.load_balancer_managed_cert.value // empty' 2>/dev/null || true)
fi

if [ -z "$ip" ]; then
  echo "No Load Balancer IP found in terraform outputs. Ensure the LB is created and has a forwarding IP."
else
  echo "Load Balancer IP: $ip"
fi

if [ -z "$domains" ]; then
  echo "No domains were provided and no managed certificate output found. Pass domain names as arguments or configure 'managed_certificate_domains' in the LB module."
fi

if [ -n "$ip" ] && [ -n "$domains" ]; then
  echo
  echo "DNS A records to create (point to LB IP):"
  for d in $domains; do
    echo "  $d -> A $ip"
  done
  echo
  echo "After DNS is created and propagated, the Google-managed certificate controller will provision the cert automatically."

  if [ $CREATE_RECORDS -eq 1 ]; then
    if [ -z "$ZONE" ]; then
      echo "--create-records given but --zone not set. Aborting creation."
      exit 1
    fi
    if ! command -v gcloud >/dev/null 2>&1; then
      echo "gcloud is required to create Cloud DNS records. Install/authorize gcloud and retry."
      exit 1
    fi

    echo "Creating DNS records in Cloud DNS zone: $ZONE"
    # start transaction
    gcloud dns record-sets transaction start --zone="$ZONE"
    for d in $domains; do
      echo "Adding A record for $d -> $ip"
      gcloud dns record-sets transaction add "$ip" --name="$d." --ttl=300 --type=A --zone="$ZONE"
    done
    echo "Executing transaction..."
    gcloud dns record-sets transaction execute --zone="$ZONE"
    echo "DNS transaction executed. Verify propagation with 'dig' or via your DNS provider tools."
  fi
else
  echo "Skipping DNS creation because either IP or domains are missing."
fi

# Optional: poll certificate status if gcloud and certificate self link available
if [ -n "$cert_link" ] && command -v gcloud >/dev/null 2>&1; then
  echo
  echo "Polling managed certificate status (using gcloud). This may take several minutes..."
  cert_name=$(basename "$cert_link")
  project=$(terraform output -json 2>/dev/null | jq -r '.project_id.value // empty' 2>/dev/null || true)
  if [ -z "$project" ]; then
    project=${TF_VAR_project_id:-$(gcloud config get-value project 2>/dev/null || echo "")}
  fi
  if [ -z "$project" ]; then
    echo "Project not found; set TF_VAR_project_id or gcloud project config to poll status."
    exit 0
  fi
  for i in {1..30}; do
    status=$(gcloud compute ssl-certificates describe "$cert_name" --project "$project" --format='get(managed.status)' 2>/dev/null || true)
    echo "Attempt $i: managed.status=$status"
    if [ "$status" = "ACTIVE" ]; then
      echo "Managed certificate is ACTIVE"
      exit 0
    fi
    sleep 10
  done
  echo "Timed out waiting for certificate to become ACTIVE."
fi

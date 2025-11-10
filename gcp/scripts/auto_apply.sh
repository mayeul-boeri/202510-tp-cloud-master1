#!/usr/bin/env bash
set -euo pipefail

# Simple helper to automate import (KMS) + terraform apply/destroy
# Usage:
#   ./scripts/auto_apply.sh apply  # runs import if needed, then plan+apply
#   ./scripts/auto_apply.sh destroy  # runs terraform destroy
# Requires: gcloud, terraform

PROJECT=${PROJECT_ID:-}
if [ -z "$PROJECT" ]; then
  echo "Please set PROJECT_ID environment variable, e.g. export PROJECT_ID=your-project-id" >&2
  exit 2
fi

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

ACTION=${1:-apply}

echo "Project: $PROJECT"

if ! command -v terraform >/dev/null 2>&1; then
  echo "terraform not found in PATH" >&2
  exit 1
fi

if ! command -v gcloud >/dev/null 2>&1; then
  echo "gcloud not found in PATH; the script can still run terraform but KMS import may not be possible." >&2
fi

case "$ACTION" in
  apply)
    terraform init -input=false

    # If KMS module is enabled in tfvars and a KeyRing exists, attempt to import it so terraform can manage it
    KR_NAME="projects/$PROJECT/locations/us-central1/keyRings/tpcloud-gcp-vpc-kr"
    if gcloud kms keyrings list --project="$PROJECT" --location=us-central1 --filter="name:$KR_NAME" --format='value(name)' >/dev/null 2>&1; then
      echo "KeyRing may exist; attempting to import KMS resources into state (no-op if already imported)"
      set +e
      terraform import -var "project_id=$PROJECT" -var 'enable_kms=true' "module.kms[0].google_kms_key_ring.this" "$KR_NAME" || true
      terraform import -var "project_id=$PROJECT" -var 'enable_kms=true' "module.kms[0].google_kms_crypto_key.this" "$KR_NAME/cryptoKeys/tpcloud-gcp-vpc-key" || true
      set -e
    fi

    terraform plan -var-file=enable-samples.tfvars -var "project_id=$PROJECT" -out=tfplan
    terraform apply -auto-approve tfplan
    ;;

  destroy)
    terraform init -input=false
    terraform destroy -var-file=enable-samples.tfvars -var "project_id=$PROJECT" -auto-approve
    ;;

  *)
    echo "Unknown action: $ACTION" >&2
    exit 2
    ;;
esac

echo "Done"

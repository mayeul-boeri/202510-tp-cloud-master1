# Load Balancer - Managed Certificate workflow

This document explains how to use the managed-certificate helper and the workflow to validate Google-managed SSL certificates for the load balancer.

Files
- `modules/load_balancer` contains the LB scaffold and accepts `managed_certificate_domains` (list of domains).
- `scripts/lb_managed_cert_helper.sh` prints the LB frontend IP and suggested DNS A records and can optionally create them in Cloud DNS.

Quick flow
1. Configure `modules/load_balancer` in `gcp/terraform/main.tf` and set `managed_certificate_domains` to the domains you want a managed certificate for.
2. `terraform apply` the LB module so the global forwarding rule and (optionally) managed certificate resource exist. The managed cert will initially be in provisioning state until DNS is configured.
3. Run the helper to see required DNS records:

```bash
cd gcp/terraform
./scripts/lb_managed_cert_helper.sh domain.example.com
```

4. To let the script create DNS A records in Cloud DNS, provide your managed zone name and the `--create-records` flag (requires gcloud auth and permissions):

```bash
./scripts/lb_managed_cert_helper.sh --zone my-managed-zone --create-records domain.example.com
```

Notes & permissions
- The script uses `terraform output` to get the LB IP and managed cert self-link. Run it from the `gcp/terraform` directory (after apply).
- To create DNS records via the script you need `gcloud` installed and configured for the target project and permission to modify the Cloud DNS managed zone.
- The script will attempt to create A records using `gcloud dns record-sets transaction` commands.

Caveats
- Google-managed certificates require DNS to be correctly configured before they reach ACTIVE. Propagation delay varies.
- If you prefer to manage DNS via Terraform, you can add a `google_dns_record_set` resource in your configuration. This script opts to do DNS modifications via gcloud to keep the Terraform LB module self-contained and optional.

If you want, I can also add an optional `managed_zone` variable to the LB module and create `google_dns_record_set` resources directly in Terraform (I avoided it initially to prevent cross-module dependency/count complexity). If you'd rather manage DNS in Terraform, tell me the desired behavior and I will implement it.

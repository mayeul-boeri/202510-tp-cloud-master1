Module AWS VPC — Réseau

Description
- Crée un VPC AWS avec sous‑réseaux publics et privés, Internet Gateway et NAT Gateway optionnelle.

Prérequis
- Compte AWS et permissions pour créer VPC, Subnets, IGW, NAT et routes.

Variables d'entrée
- `project_name` (string)
- `vpc_cidr` (string)
- `az_count` (number) — défaut : 2

Outputs
- `vpc_id`, `public_subnet_ids`, `private_subnet_ids`, `internet_gateway_id`, `nat_gateway_id`, `route_table_public_id`, `route_table_private_id`.

Exemple d'utilisation
module "vpc" {
  source       = "../modules/vpc"
  project_name = var.project_name
}

Notes
- Vérifiez les quotas de VPC et d'IP dans la région ciblée avant de créer de nombreux subnets.

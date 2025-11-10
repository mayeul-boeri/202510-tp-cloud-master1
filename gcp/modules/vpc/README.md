Module VPC — Réseau GCP

Description
- Ce module crée un réseau VPC et des sous‑réseaux (publics/privés). Il peut aussi provisionner Cloud Router et Cloud NAT si nécessaire.

Prérequis
- API Compute activée.

Variables d'entrée
- `project_id` (string) : ID du projet.
- `region` (string) : région par défaut pour certaines ressources.
- `network_name` (string) : nom du VPC.
- `subnets` (list(object)) : liste d'objets {name, ip_cidr_range, region, private}.
- `enable_nat` (bool) — défaut `false` pour créer Cloud NAT.

Outputs
- `network_self_link` : self_link du réseau.
- `subnet_self_links` : liste des self_link des sous‑réseaux créés.

Exemple d'utilisation
module "vpc" {
  source     = "../modules/vpc"
  project_id = var.project_id
  network_name = "tpcloud-vpc"
}

Notes & permissions
- Nécessite `compute.networks.create` pour l'utilisateur exécutant Terraform. Si `enable_nat=true`, prévoir `compute.routers.create` et `compute.routers.update`.

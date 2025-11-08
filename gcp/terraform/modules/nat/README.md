Module NAT — Cloud Router & Cloud NAT

Description
- Fournit l'infrastructure nécessaire (Cloud Router et Cloud NAT) pour permettre aux sous‑réseaux privés d'accéder à Internet de manière contrôlée.

Prérequis
- API Compute activée.

Variables principales
- `project_id` (string)
- `region` (string) — défaut `us-central1`.
- `router_name` (string)
- `nat_name` (string)
- `network_self_link` (string) : self_link du réseau où attacher le routeur.
- `nat_ip_allocate_option` (string) — `AUTO_ONLY` ou `MANUAL_ONLY`.
- `source_subnetwork_ip_ranges_to_nat` (string) — ex: `ALL_SUBNETWORKS_ALL_IP_RANGES`.
- `subnetwork_self_links` (list(string)) — utilisé si `LIST_OF_SUBNETWORKS`.

Outputs
- `router_name`, `nat_name`, `router_self_link`.

Exemple
module "nat" {
  source     = "../modules/nat"
  project_id = var.project_id
  network_self_link = module.vpc.network_self_link
}

Notes
- Les opérations sur Cloud Router/NAT exigent `compute.routers.*` permissions. Vérifiez les journaux Cloud NAT pour diagnostiquer les allocations IP.

Module Load Balancer — HTTP(S) global

Description
- Ce module crée un Load Balancer global HTTP(S) avec options pour certificats gérés ou fournis, gestion de backend (bucket GCS ou groupe d'instances) et enregistrement DNS optionnel.

Prérequis
- Activer les APIs : Compute, Cloud DNS (si `manage_dns_records = true`).

Variables d'entrée (extraits)
- `project_id` (string) : ID du projet.
- `enable` (bool) — défaut `false` : active la création du LB.
- `name_prefix` (string) — préfixe de nommage.
- `managed_certificate_domains` (list(string)) : domaines pour certificat géré.
- `ssl_certificate_self_links` (list(string)) : certificats déjà provisionnés à attacher.
- `backend_instance_group_self_link` (string) : self_link d'un groupe d'instances utilisé comme backend.

Outputs principaux
- `forwarding_rule_ip` : adresse IP publique du load balancer.
- `backend_service_self_link` : self_link du backend service (si créé).

Exemple d'utilisation
module "load_balancer" {
  source     = "../modules/load_balancer"
  project_id = var.project_id
  enable     = true
  enable_backend_service = true
}

Bonnes pratiques & permissions
- Pour la production, privilégiez HTTPS (managed certs ou ACM). L'utilisateur Terraform doit disposer des rôles Compute Network Admin / Compute Admin et, si DNS est géré, des droits Cloud DNS.
- La création de certificats gérés nécessite des enregistrements DNS pointant sur l'IP du LB et peut prendre plusieurs minutes.

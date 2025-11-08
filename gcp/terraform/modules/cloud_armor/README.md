Module Cloud Armor — Security Policy

Description
- Crée une politique Cloud Armor et permet de définir des règles simples (par ex. blocage d'IP ranges). Utile pour protéger les backends HTTP(S) exposés.

Prérequis
- API Compute activée.

Variables d'entrée
- `security_policy_name` (string) — nom de la politique (défaut : `tpcloud-security-policy`).
- `description` (string) — description optionnelle.
- `block_ip_ranges` (list(string)) — liste de plages IP à bloquer.

Outputs
- `security_policy_name` : nom de la politique.
- `security_policy_self_link` : self_link de la ressource.

Exemple
module "cloud_armor" {
  source     = "../modules/cloud_armor"
  project_id = var.project_id
  block_ip_ranges = ["1.2.3.0/24"]
}

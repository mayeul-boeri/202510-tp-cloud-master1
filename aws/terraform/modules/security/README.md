Module Sécurité — Security Groups & NACL

Description
- Crée/retourne les groupes de sécurité, Network ACLs et éléments de sécurité réseau utilisés par l'application.

Prérequis
- Permissions AWS pour créer Security Groups et Network ACLs.

Variables d'entrée
- `project_name`, `vpc_id`, `vpc_cidr`, `private_subnet_ids`.

Outputs
- `web_sg_id`, `db_sg_id`, `nacl_id`.

Exemple
module "security" {
  source = "../modules/security"
  project_name = var.project_name
}

Module RDS — Base de données

Description
- Provisionne une instance RDS (MySQL/Postgres selon configuration) et gère le mot de passe (optionnellement stocké en sortie ou via un secret).

Prérequis
- Permissions pour créer des RDS, sous‑réseaux et security groups.

Variables d'entrée
- `project_name`, `private_subnet_ids`, `db_instance_class`, `db_allocated_storage`, `db_username`, `db_password` (sensible), `db_sg_id`.

Outputs
- `db_instance_id`, `db_endpoint`, `db_password` (sensible), `db_arn`.

Exemple d'utilisation
module "db" {
  source = "../modules/db"
  project_name = var.project_name
}

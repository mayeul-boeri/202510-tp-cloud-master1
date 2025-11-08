Module Backup — Sauvegardes AWS

Description
- Configure AWS Backup (vaults, plans) pour protéger RDS, S3 et autres ressources critiques.

Prérequis
- Permissions AWS Backup et accès aux ressources à protéger.

Variables d'entrée
- `project_name` (string)

Outputs
- `backup_vault_name`, `backup_plan_id`.

Exemple d'utilisation
module "backup" {
  source = "../modules/backup"
  project_name = var.project_name
}

Module IAM AWS — Rôles & profils

Description
- Crée des rôles IAM, politiques et instance profiles pour les instances EC2 et autres composants.

Prérequis
- Permissions IAM pour créer des rôles et attacher des policies.

Variables d'entrée
- `project_name` (string)

Outputs
- `instance_profile_name`, `role_name`.

Exemple d'utilisation
module "iam" {
  source = "../modules/iam"
  project_name = var.project_name
}

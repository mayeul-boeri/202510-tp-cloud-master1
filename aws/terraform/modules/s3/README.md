Module S3 — Bucket

Description
- Crée un bucket S3 et configure le versioning / ACL selon les variables.

Prérequis
- Permissions S3 pour créer des buckets et configurer la politique de chiffrement si nécessaire.

Variables d'entrée
- `project_name` (string)
- `bucket_name` (string) — optionnel.
- `enable_acl` (bool) — défaut : false.

Outputs
- `bucket_id`, `bucket_arn`.

Exemple
module "s3" {
  source = "../modules/s3"
  project_name = var.project_name
}

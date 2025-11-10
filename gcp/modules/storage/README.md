Module: storage

Purpose

Inputs

Outputs

Example
Module storage — Bucket GCS

Description
- Ce module crée et configure un bucket Google Cloud Storage. Il prend en charge le versioning, la politique de cycle de vie et l'option de chiffrement CMEK via une clé KMS existante.

Prérequis
- Avoir activé l'API Cloud Storage pour le projet.

Variables d'entrée
- `project_id` (string) : ID du projet GCP.
- `name` (string) : nom explicite du bucket (laisser vide pour génération automatique).
- `location` (string) — défaut : `US` : région du bucket.
- `versioning` (bool) — défaut : `false` : active le versioning des objets.
- `force_destroy` (bool) — défaut : `false` : permet la suppression du bucket même s'il contient des objets.
- `lifecycle_days` (number) — défaut : `365` : durée en jours avant expiration des objets selon la policy.
- `kms_key_name` (string) — défaut : `""` : nom complet d'une clé KMS (CMEK) à utiliser pour chiffrer le bucket.

Outputs
- `bucket_name` : nom du bucket créé.
- `bucket_self_link` : self_link du bucket.

Exemple d'utilisation
module "storage" {
  source     = "../modules/storage"
  project_id = var.project_id
  name       = "tpcloud-app-bucket"
  versioning = true
}

Notes et permissions
- L'utilisateur exécutant Terraform doit disposer des permissions `storage.buckets.create` et `storage.buckets.update`.

# Storage module

This module creates a Google Cloud Storage bucket with sensible defaults for tests and demos.

Features
- Versioning enabled by default (configurable)
- Lifecycle rule to expire objects after a configurable number of days
- Uniform bucket-level access and optional force_destroy

Usage
1. Enable the module from the root module by setting `enable_storage = true` and providing a globally-unique bucket name.
2. For production, configure a KMS key and set `kms_key_name` to use CMEK.

Notes
- Bucket names are global; ensure the name you choose is unique across GCS.
- Consider adding IAM bindings or a separate `google_storage_bucket_iam_member` resource to grant application/service accounts access.

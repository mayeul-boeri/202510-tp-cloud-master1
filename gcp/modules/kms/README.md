Module KMS — KeyRing & CryptoKey

Description
- Provisionne un KeyRing et une CryptoKey Google KMS. Le module est prévu pour être activé optionnellement par `enable_kms` dans le module racine.

Prérequis
- API Cloud KMS activée.

Variables d'entrée
- `project_id` (string)
- `location` (string) — défaut `us-central1`.
- `name_prefix` (string) — préfixe de nommage.

Outputs
- `crypto_key_id` : identifiant de la CryptoKey créée.

Permissions & remarques
- Les opérations KMS exigent des permissions élevées (p.ex. `roles/cloudkms.admin`). Si des keyrings/keys existent déjà, il est souvent nécessaire d'importer ces ressources dans l'état Terraform (`terraform import`) avant d'appliquer.

Exemple
module "kms" {
  source     = "../modules/kms"
  project_id = var.project_id
  location   = "us-central1"
}

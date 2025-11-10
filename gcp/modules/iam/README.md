Module IAM — Service Accounts

Description
- Crée les comptes de service utilisés par les instances et le déploiement (instance SA, deployer SA) et applique les bindings IAM nécessaires.

Prérequis
- Avoir l'API IAM activée et disposer des droits pour créer des service accounts et gérer des IAM bindings.

Variables d'entrée
- `project_id` (string)
- `name_prefix` (string) — préfixe pour nommer les comptes de service.

Outputs
- `instance_service_account_email` : email du compte de service pour les instances.
- `deployer_service_account_email` : email du compte de déploiement.

Exemple d'utilisation
module "iam" {
  source     = "../modules/iam"
  project_id = var.project_id
}

Remarques
- La suppression de comptes de service peut nécessiter des permissions IAM élevées (`iam.serviceAccounts.delete`).

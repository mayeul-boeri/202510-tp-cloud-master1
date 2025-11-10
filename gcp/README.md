# GCP Terraform (tpcloud) — Quick start

This folder provisions a small GCP environment: VPC, Managed Instance Group (nginx), External HTTP Load Balancer, Cloud SQL (optional), KMS (optional), and Monitoring.

Goal: a single `terraform apply` (with a variables file) should bring everything up. Destroying everything is handled via `terraform destroy`.

IMPORTANT: Some operations require the account you use to run `terraform` and `gcloud` to have sufficient IAM permissions (Owner or equivalent) to create and delete service accounts and KMS keyrings/keys. See notes below.

Prerequisites
 - Install Terraform (>= 1.0)
 - Install gcloud SDK and authenticate (required for some helper scripts and for importing existing resources)
 - Enable the needed APIs in the target project: compute.googleapis.com, sqladmin.googleapis.com, kms.googleapis.com, monitoring.googleapis.com, servicenetworking.googleapis.com

Quick steps (recommended)

1) Authenticate gcloud and set project

```bash
# Login and choose the account that has Owner permissions on the project
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
export PROJECT_ID=YOUR_PROJECT_ID
```

2) Inspect / customize variables

Edit `enable-samples.tfvars` to set values (monitoring email, enable_kms, etc.). If you want a quick run, the file already contains a sample startup script that installs nginx.

3) Run Terraform apply

```bash
cd gcp/terraform
terraform init
terraform plan -var-file=enable-samples.tfvars -var "project_id=$PROJECT_ID"
terraform apply -var-file=enable-samples.tfvars -var "project_id=$PROJECT_ID"
```

Notes about KMS & existing keyrings
 - If an existing KeyRing / CryptoKey with the same name exists in the project, Terraform cannot create another resource with the same name.
 - The helper script `scripts/auto_apply.sh` will attempt to detect and import an existing KeyRing/CryptoKey into the Terraform state so the apply/destroy lifecycle can be managed. This import uses `terraform import` and requires `gcloud` to be authenticated with a user that has permissions to view/import.
 - If you don't have Owner permissions, you can disable KMS during first provisioning by setting `enable_kms = false` in `enable-samples.tfvars`. After the infra is up you can enable KMS and run `terraform apply` again (with the right permissions) so Terraform manages the KMS resources.

Destroy everything

```bash
cd gcp/terraform
terraform destroy -var-file=enable-samples.tfvars -var "project_id=$PROJECT_ID"
```

Automated helper
 - `scripts/auto_apply.sh` automates import (if KMS exists), plan, apply and destroy. It requires `bash`, `gcloud` and `terraform` and that your gcloud user has the necessary permissions.

Permissions checklist (minimum recommended for full automation)
 - roles/owner (or equivalent) on the target project OR at least:
   - compute.admin, compute.instanceAdmin, compute.networkAdmin
   - iam.serviceAccountAdmin, iam.serviceAccountKeyAdmin
   - cloudkms.admin
   - sqladmin.admin
   - monitoring.editor

If you want me to enforce stricter provider-native automation (no gcloud at all), I can refactor the module further — but for KMS/service-account import and some edge-cases we rely on `gcloud` tools to seed Terraform state when pre-existing resources are present.

If anything fails, paste the error here and I will fix the scripts or adjust the Terraform code accordingly.
# GCP Terraform

### Prérequis
- gcloud SDK installé et authentifié (Application Default Credentials ou compte de service)
- Terraform v1.0+ (le projet a été testé avec Terraform v1.x)
- Un projet GCP valide et les permissions nécessaires (compute.networkAdmin, compute.routerAdmin, compute.networkUser selon les actions)

### Prérequis & configuration
Les instructions détaillées d'installation et de configuration sont déplacées dans la documentation dédiée :

- `docs/PREREQUISITES.md` — installation des outils (Debian/Ubuntu) et vérifications
- `docs/IAM_SETUP.md` — tutoriel pas‑à‑pas pour créer un compte de service, générer une clé JSON et configurer les variables d'environnement

Consultez ces fichiers pour les commandes complètes et les bonnes pratiques. Exemples rapides :

```bash
# voir les guides :
less docs/PREREQUISITES.md
less docs/IAM_SETUP.md

# puis, depuis gcp/terraform :
terraform init
terraform plan -var="project_id=YOUR_PROJECT_ID"

### Accès rapide (développement local)

Pour un développement interactif local, utilisez votre compte utilisateur Google :

```bash
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
export TF_VAR_project_id=YOUR_PROJECT_ID
```

Ensuite depuis `gcp/terraform` :

```bash
terraform init
terraform plan -var="project_id=$TF_VAR_project_id"
```

Pour l'automatisation (CI), conservez la méthode compte de service décrite dans `docs/IAM_SETUP.md`.
```

### Variables importantes
- `project_id` : identifiant du projet GCP où déployer (obligatoire)
- `region` : région principale (ex: `us-central1`)
- `network_name` : nom du réseau VPC créé
- `subnets` : liste d'objets décrivant les subnets (name, ip_cidr_range, region, private)

Les valeurs par défaut se trouvent dans `variables.tf`. Vous pouvez fournir un fichier `terraform.tfvars` ou passer `-var` à la ligne de commande.

### Procédure d'utilisation
1. Se placer dans `gcp/terraform` :
	```bash
	cd gcp/terraform
	```
2. Initialiser Terraform et télécharger les providers :
	```bash
	terraform init
	```
3. (Optionnel) personnaliser les variables via `terraform.tfvars` ou en passant `-var` à la ligne de commande.
4. Vérifier le plan :
	```bash
	terraform plan -out=plan.tfplan -var='project_id=YOUR_PROJECT_ID'
	```
5. Appliquer :
	```bash
	terraform apply "plan.tfplan"
	```

### Vérifications post-déploiement
- Vérifier que le réseau existe :
  ```bash
  gcloud compute networks describe $(terraform output -raw network_self_link | sed -E 's#.*/networks/##') --project=$(terraform output -raw project_id || echo YOUR_PROJECT_ID)
  ```
- Lister les subnets :
  ```bash
  gcloud compute networks subnets list --filter="network:$(terraform output -raw network_self_link | sed -E 's#.*/networks/##')" --project=$(terraform output -raw project_id || echo YOUR_PROJECT_ID)
  ```

### Extension Cloud NAT / Router
Le scaffold ajoute maintenant un module `nat` (Cloud Router + Cloud NAT) invoqué depuis `main.tf`. Par défaut le NAT est configuré en `AUTO_ONLY` et couvre tous les sous-réseaux. Ajustez `nat_ip_allocate_option` et `source_subnetwork_ip_ranges_to_nat` dans le module si vous souhaitez un comportement différent.

### Bonnes pratiques et notes
- Utiliser des comptes de service et IAM least-privilege pour les runs Terraform en CI.
- Pour des tests, utilisez un projet GCP isolé pour éviter des coûts collatéraux.
- Pour NATs avancés (IP statiques ou NAT par sous-réseau), étendre le module `modules/nat`.
- Nettoyer les ressources avec `terraform destroy` après les essais pour éviter les coûts.

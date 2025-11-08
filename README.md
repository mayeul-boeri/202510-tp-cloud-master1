
# TP Services Cloud Avancés — Multi‑Cloud (AWS, GCP)

Courte présentation
- Ce dépôt contient des modules Terraform pour déployer une plateforme web sur AWS et GCP. Les dossiers principaux :
	- `aws/terraform` — modules et exemples pour AWS
	- `gcp/terraform` — modules et exemples pour GCP

Raccourci pour démarrer
- Installer Terraform : voir `docs/INSTALL_TERRAFORM.md`.
- Choisir la plateforme : aller dans `aws/terraform` ou `gcp/terraform`.
- Exemple rapide (GCP) :

```bash
# configurer gcloud et le projet
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
export PROJECT_ID=YOUR_PROJECT_ID

cd gcp/terraform
terraform init
terraform plan -var-file=enable-samples.tfvars -var "project_id=$PROJECT_ID"
terraform apply -var-file=enable-samples.tfvars -var "project_id=$PROJECT_ID"
```

Notes rapides
- Certains modules (KMS, suppression de comptes de service) exigent des permissions élevées (Owner ou rôles équivalents). Si vous manquez de droits, désactivez `enable_kms` dans les tfvars et réessayez.
- Les README de chaque module sont disponibles sous `*/modules/*/README.md` — ils sont courts et en français.

Besoin d'aide
- Ouvrez une issue ou demandez ici ce que vous voulez automatiser ensuite.


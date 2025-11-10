# TP Services Cloud Avancés – Multi-Cloud (AWS, Azure, GCP)

## Suivi du Projet

Ce projet vise à déployer une infrastructure web hautement disponible, sécurisée et résiliente sur AWS, Azure et Google Cloud Platform, en utilisant exclusivement l'Infrastructure as Code (IaC).

---

## Table des matières

- [Objectifs](#objectifs)
- [Livrables](#livrables)
- [Documentation technique](#documentation-technique)

---

## Objectifs

- Déployer une architecture réseau multi-cloud (VPC/VNet)
- Implémenter haute disponibilité et résilience
- Configurer équilibreurs de charge et auto-scaling
- Gérer identité et accès (IAM)
- Sécuriser l’infrastructure (WAF, SG, chiffrement)
- Sauvegarde et reprise après sinistre
- Monitoring et alertes
- Automatiser tout via IaC (Terraform, CloudFormation, Bicep)


# TP Services Cloud Avancés — Multi‑Cloud (AWS, Azure, GCP)

Courte présentation
- Ce dépôt contient des modules Terraform pour déployer une plateforme web sur AWS et GCP. Les dossiers principaux :
	- `aws` - modules et exemples pour AWS
	- `azure` - modules et exemples pour Azure
	- `gcp` - modules et exemples pour GCP

Raccourci pour démarrer
- Installer Terraform : voir `docs/INSTALL_TERRAFORM.md`.
- Choisir la plateforme : aller dans `aws`.
- Exemple rapide (GCP) :

```bash
# configurer gcloud et le projet
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
export PROJECT_ID=YOUR_PROJECT_ID

cd gcp
terraform init
terraform plan -var-file=enable-samples.tfvars -var "project_id=$PROJECT_ID"
terraform apply -var-file=enable-samples.tfvars -var "project_id=$PROJECT_ID"
```

Pour les autres, il suffit d'aller dans le dossier aws ou azure puis :

```bash
terraform init
terraform plan -var-file="var.tfvars"
terraform apply -var-file="var.tfvars"
```

Notes rapides
- Certains modules (KMS, suppression de comptes de service) exigent des permissions élevées (Owner ou rôles équivalents). Si vous manquez de droits, désactivez `enable_kms` dans les tfvars et réessayez.
- Les README de chaque module sont disponibles sous `*/modules/*/README.md` — ils sont courts et en français.



Liens utiles

- Configuration de [AWS CLI](https://docs.aws.amazon.com/cli/latest/reference/configure/?utm_source=chatgpt.com)
- Configuration de [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/get-started-with-azure-cli?view=azure-cli-latest&utm_source=chatgpt.com)
- Configuratin de [GCP CLI](https://cloud.google.com/sdk/docs/configurations?utm_source=chatgpt.com)

---

## Documentation technique

- Configurations réseau (VPC/VNet, sous-réseaux, routage)
- Sécurité (SG/NSG, WAF, IAM, chiffrement)
- Sauvegarde et reprise (RTO/RPO)
- Monitoring et alertes

---

## Notes

- **Full IaC** : Toutes les ressources sont déployées via scripts d’automatisation (Terraform, CloudFormation, Bicep)
- **Suivi** : Cochez chaque étape au fur et à mesure
- **Schémas** : Ajoutez vos diagrammes dans le dossier `/docs` ou en pièce jointe


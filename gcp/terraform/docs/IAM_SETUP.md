# Tutoriel IAM — accès local (gcloud) et création d'un compte de service pour CI

But : montrer la méthode recommandée pour le développement local (utiliser `gcloud auth login`) puis fournir le tutoriel pour créer un compte de service à utiliser en CI.

## Développement local (recommandé)

Pour du développement interactif, privilégiez l'authentification par compte utilisateur :

```bash
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
export TF_VAR_project_id=YOUR_PROJECT_ID
cd gcp/terraform
terraform init
terraform plan -var="project_id=$TF_VAR_project_id"
```

Cette méthode évite de manipuler des clés JSON locales. Utilisez un compte de service seulement pour l'automatisation (CI).

---

# Tutoriel IAM — création d'un compte de service pour Terraform (avec variables d'environnement)

But : créer un compte de service, lui assigner des rôles réseau, générer une clé JSON et configurer les variables d'environnement pour Terraform (usage CI).

1) Définir les variables (remplacez les valeurs)
```bash
export PROJECT=YOUR_PROJECT_ID
export SA_NAME=terraform-sa
export SA_EMAIL="${SA_NAME}@${PROJECT}.iam.gserviceaccount.com"
```

2) Créer le compte de service
```bash
gcloud iam service-accounts create $SA_NAME \
  --display-name="Terraform Service Account" --project=$PROJECT
gcloud iam service-accounts list --project=$PROJECT
```

3) Assigner les rôles (least-privilege recommandé)
```bash
# rôles réseau nécessaires pour VPC/NAT
gcloud projects add-iam-policy-binding $PROJECT \
  --member="serviceAccount:$SA_EMAIL" --role="roles/compute.networkAdmin"
gcloud projects add-iam-policy-binding $PROJECT \
  --member="serviceAccount:$SA_EMAIL" --role="roles/compute.routerAdmin"

# (optionnel pour tests rapides)
gcloud projects add-iam-policy-binding $PROJECT \
  --member="serviceAccount:$SA_EMAIL" --role="roles/editor"
```

4) Générer la clé JSON et exporter la variable d'environnement
```bash
gcloud iam service-accounts keys create ${SA_NAME}-key.json \
  --iam-account=$SA_EMAIL --project=$PROJECT
chmod 600 ${SA_NAME}-key.json
export GOOGLE_APPLICATION_CREDENTIALS="$(pwd)/${SA_NAME}-key.json"
# rendre le project_id disponible comme variable Terraform
export TF_VAR_project_id=$PROJECT
```

5) Vérifier et lancer Terraform
```bash
gcloud auth list
gcloud auth application-default print-access-token || true
cd gcp/terraform
terraform init
terraform plan -var="project_id=$PROJECT"
```

6) Nettoyage / révocation
```bash
# supprimer la clé locale
rm -f ${SA_NAME}-key.json

# lister les clés et supprimer par KEY_ID si besoin
gcloud iam service-accounts keys list --iam-account=$SA_EMAIL --project=$PROJECT
# puis:
# gcloud iam service-accounts keys delete KEY_ID --iam-account=$SA_EMAIL --project=$PROJECT
```

Sécurité
- Ne commitez jamais la clé JSON. Ajoutez `*.json` ou `${SA_NAME}-key.json` à `.gitignore`.
- En CI, stockez la clé dans les secrets du runner et écrivez-la temporairement dans le job avant d'exporter `GOOGLE_APPLICATION_CREDENTIALS`

Remarque importante
- Si vous avez généré une clé localement et qu'un fichier `gcp/terraform/sa-key.json` existe encore sur votre disque ou dans l'arborescence du projet, supprimez-le immédiatement :

```bash
rm -f gcp/terraform/sa-key.json
```

- Après suppression locale, pensez à révoquer la clé côté Google Cloud (obligatoire si la clé a été potentiellement exposée) :

```bash
# lister les clés pour récupérer l'ID
gcloud iam service-accounts keys list --iam-account=$SA_EMAIL --project=$PROJECT
# supprimer la clé identifiée par KEY_ID
gcloud iam service-accounts keys delete KEY_ID --iam-account=$SA_EMAIL --project=$PROJECT
```

Cette étape évite qu'une clé supprimée localement reste active et potentiellement réutilisable par un attaquant.
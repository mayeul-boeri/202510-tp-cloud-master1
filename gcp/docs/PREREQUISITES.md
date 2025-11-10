# Prérequis — GCP Terraform

But : installer et vérifier les outils nécessaires pour travailler avec `gcp/terraform`.

Outils requis
- Google Cloud SDK (`gcloud`)
- Terraform v1.0+ (recommandé v1.x)
- (optionnel) `jq`, `unzip` pour manipulations

Installations rapides

Debian / Ubuntu
```bash
# Google Cloud SDK
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
gcloud init

# Terraform (dépôt HashiCorp)
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install -y terraform

# utilitaires
sudo apt-get install -y jq unzip
```

Vérifications
```bash
gcloud --version
terraform -v
jq --version || true
```

Notes utiles
- Après installation, configurez le projet et l'authentification (voir `IAM_SETUP.md`).
- Pour CI, préférez installer/mettre en cache les dépendances dans l'image runner et stocker les credentials dans les secrets du runner.
- Lancez toujours `terraform init` dans `gcp/terraform` avant `plan`/`apply`.

Activer les APIs GCP
-------------------
Certaines ressources (Compute, Cloud NAT, etc.) requièrent l'activation d'APIs GCP avant le premier usage. Vous pouvez activer manuellement l'API Compute depuis la console ou utiliser le script fourni :

```bash
# Exemple : activer manuellement
gcloud services enable compute.googleapis.com --project=YOUR_PROJECT_ID

# Ou utiliser le script automatisé (préféré)
PROJECT=YOUR_PROJECT_ID ./scripts/enable-apis.sh
```

Le script active aussi `servicenetworking.googleapis.com` et `iam.googleapis.com`.

Cloud Armor (WAF)
------------------
Le module Cloud Armor nécessite également l'API Compute (Cloud Armor est exposé via Compute). Si vous utilisez des fonctionnalités avancées (Managed Protection, WAF rules), assurez-vous que les API associées sont activées et que vous avez les rôles nécessaires (`roles/compute.securityAdmin` ou équivalent).

---

Fichier lié : `IAM_SETUP.md` (tutoriel de création de compte de service et variables d'environnement).
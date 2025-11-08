Installation rapide de Terraform

Ce fichier explique brièvement comment installer Terraform sur Linux (Debian/Ubuntu) et macOS.

Linux (Debian/Ubuntu)

```bash
# ajouter le dépôt HashiCorp (Debian/Ubuntu)
sudo apt-get update
sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install -y terraform

# vérifier
terraform version
```

macOS (Homebrew)

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
terraform version
```

Remarques
- Ce dépôt a été testé avec Terraform 1.x ; vérifiez `terraform version` et assurez‑vous d'utiliser >= 1.0.
- Pour CI, installez Terraform via l'outil de votre pipeline (ex. actions/setup-terraform, ou image Docker officielle).

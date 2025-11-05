# AWS Terraform Project

Ce projet permet de déployer une infrastructure AWS complète à l'aide de Terraform. Il inclut la gestion du réseau (VPC, subnets, NAT, IGW), la sécurité (groupes de sécurité, IAM, WAF), le monitoring (CloudWatch), le stockage (S3, Backup), le calcul (ASG, ALB, Launch Template), et la base de données (RDS).

## Prérequis
- [Terraform](https://www.terraform.io/downloads.html) installé
- Un compte AWS avec les permissions nécessaires
- Configurer vos identifiants AWS (`aws configure` ou variables d'environnement)

## Structure du projet
- Chaque fichier `.tf` correspond à une ressource ou un module AWS
- Les variables sont définies dans `variables.tf` et leurs valeurs dans `var.tfvars`

## Lancement du projet

1. **Initialiser Terraform**
   ```bash
   terraform init
   ```

2. **Vérifier le plan de déploiement**
   ```bash
   terraform plan -var-file=var.tfvars
   ```

3. **Appliquer le déploiement**
   ```bash
   terraform apply -var-file=var.tfvars
   ```

4. **Détruire l'infrastructure (optionnel)**
   ```bash
   terraform destroy -var-file=var.tfvars
   ```

## Personnalisation
- Modifiez `var.tfvars` pour adapter les paramètres à votre besoin (CIDR, noms, tailles, etc.)
- Ajoutez ou modifiez les fichiers `.tf` pour étendre l'infrastructure

## Bonnes pratiques
- Versionnez vos fichiers Terraform
- Utilisez des workspaces pour séparer les environnements (dev, prod)
- Protégez vos identifiants AWS

## Documentation
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Documentation officielle AWS](https://docs.aws.amazon.com/)

---

Pour toute question, contactez l'administrateur du projet.

# AWS Terraform

Ce dossier contient la configuration Terraform utilisée pour déployer l'infrastructure AWS du projet : VPC, subnets, NAT/IGW, security groups, RDS MySQL, S3, Application Load Balancer, Auto Scaling Group (Launch Template + user data), WAF, IAM, monitoring et backup.

### Prérequis
- Terraform v1.0+ (le projet a été testé avec Terraform v1.13.x)
- AWS CLI configuré avec des credentials ayant les droits nécessaires (EC2, IAM, ELB, RDS, S3, Backup, CloudWatch)
- Un profil/compte AWS valide et une région (par défaut `us-east-1` dans `variables.tf`)

### Variables importantes
- `instance_ami` : (optionnel) AMI à utiliser pour les instances web. Si vide, la config recherche une Amazon Linux 2.
- `instance_type` : type d'instance EC2 pour les web servers (par défaut `t3.micro`).
- `asg_min_size`, `asg_desired_capacity`, `asg_max_size` : contrôlent la taille de l'ASG.

### Procédure d'utilisation (rapide)
1. Se placer dans `aws/terraform` :
   ```bash
   cd aws/terraform
   ```
2. Initialiser Terraform et télécharger les providers :
   ```bash
   terraform init
   ```
3. (Optionnel) personnaliser les variables via `terraform.tfvars` ou en passant `-var` à la ligne de commande.
4. Vérifier le plan :
   ```bash
   terraform plan -out=tpcloud
   ```
5. Appliquer :
   ```bash
   terraform apply "tpcloud"
   ```

### Vérifications post-déploiement
- Récupérer l'ALB DNS : `terraform output -raw alb_dns_name` puis visiter l'URL.
- Vérifier les targets :
  ```bash
  aws elbv2 describe-target-health --target-group-arn $(terraform output -raw target_group_arn)
  ```
- Vérifier RDS : `terraform output -raw db_endpoint`

### Démonstration du load-balancing
- Pour démontrer la distribution, faites des requêtes répétées en forçant la fermeture de la connexion (éviter HTTP keep-alive) :
  ```bash
  ALB=$(terraform output -raw alb_dns_name)
  for i in {1..50}; do curl -sS -H 'Connection: close' http://$ALB | sed -n '1,6p'; done
  ```

### Bonnes pratiques et notes
- Si les installations dans `user_data` échouent (timeouts `yum`/`apt`), privilégiez :
  - provisionner une AMI pré‑baked contenant SSM + nginx, ou
  - ajouter des retries et backoff dans `user_data`.
- Après des tests/démonstrations, remettez `asg_desired_capacity`/`min` à 1 si vous ne voulez pas payer pour plusieurs instances.
- Nettoyez les ressources temporaires (bastion, logs) après usage.
- Tout détruire avec terraform après usage (consomation de crédits) `terraform destroy`

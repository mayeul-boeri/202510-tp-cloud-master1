# TP Services Cloud Avancés – Multi-Cloud (AWS, Azure, GCP)

Ce dépôt contient l'infrastructure as code (Terraform) et les modules pour déployer une plateforme web sur plusieurs clouds. Le travail principal implémenté ici cible AWS (modules dans `aws/terraform`).

Fichiers clés
- `PROJECT_TODO.md` : copie du README historique / checklist détaillée.
- `aws/terraform/` : implementation Terraform pour AWS (VPC, Security, RDS, S3, ALB, ASG, WAF, IAM, monitoring, backup).

But rapide
- Fournir une base reproductible pour déployer une application web hautement disponible sur AWS.
- Les modules soient modulaires et réutilisables.

Pour démarrer
1. Aller dans `aws/terraform` et suivre les instructions du `aws/terraform/README.md` (prérequis, variables, commandes `terraform init/plan/apply`).
2. Vérifier les outputs (`terraform output`) pour récupérer l'URL de l'ALB, endpoint DB, etc.

Documentation par dossier
- `aws/terraform/README.md` : détails techniques, composants déployés, requirements et procédure d'utilisation.

Contact & contributions
- Ajoute des issues ou PRs sur ce dépôt pour proposer des améliorations, des corrections d'IaC, ou l'ajout d'AMIs pré‑baked.


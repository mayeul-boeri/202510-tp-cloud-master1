# TP Services Cloud Avancés – Multi-Cloud (AWS, Azure, GCP)

## Suivi du Projet

Ce projet vise à déployer une infrastructure web hautement disponible, sécurisée et résiliente sur AWS, Azure et Google Cloud Platform, en utilisant exclusivement l'Infrastructure as Code (IaC).

---

## Table des matières

- [Objectifs](#objectifs)
- [Livrables](#livrables)
- [Todolist détaillée](#todolist-détaillée)
- [Schéma d'infrastructure](#schéma-dinfrastructure)
- [Documentation technique](#documentation-technique)
- [Rapport comparatif](#rapport-comparatif)

---

## Objectifs
# TP Services Cloud Avancés – Multi-Cloud (AWS, Azure, GCP)

## Suivi du Projet

Ce projet vise à déployer une infrastructure web hautement disponible, sécurisée et résiliente sur AWS, Azure et Google Cloud Platform, en utilisant exclusivement l'Infrastructure as Code (IaC).

---

## Table des matières

- [Objectifs](#objectifs)
- [Livrables](#livrables)
- [Todolist détaillée](#todolist-détaillée)
- [Schéma d'infrastructure](#schéma-dinfrastructure)
- [Documentation technique](#documentation-technique)
- [Rapport comparatif](#rapport-comparatif)

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

---

## Livrables

- Scripts IaC pour chaque cloud
- Schémas d’architecture
- Documentation technique
- Rapport comparatif

---

## Todolist détaillée

### 1. AWS

- [x] VPC, sous-réseaux publics/privés, IGW, NAT Gateway
- [x] Tables de routage, associations
- [x] Groupes de sécurité, Network ACL
- [x] RDS MySQL Multi-AZ, subnet group, sauvegardes
- [x] S3 bucket, versioning, chiffrement
- [x] Application Load Balancer, Target Group, Listener HTTPS, ACM
- [x] Auto Scaling Group, Launch Template, User Data
- [x] WAF Web ACL, règles managées et personnalisées
- [x] IAM rôles, politiques, Identity Center, MFA
- [x] AWS Backup plan, monitoring CloudWatch, alarmes


### 2. Azure

- [ ] Resource Group, VNet, sous-réseaux, Bastion
- [ ] NSG, Azure Firewall
- [ ] Azure SQL Database, Key Vault
- [ ] Storage Account, conteneur blob, lifecycle
- [ ] Application Gateway v2 (WAF), autoscaling, certificat
- [ ] VMSS, cloud-init, autoscaling
- [ ] Azure Entra ID, groupes, MFA, Conditional Access
- [ ] RBAC, Managed Identity, accès Storage/Key Vault
- [ ] Recovery Services Vault, sauvegarde, monitoring, alertes

### 3. GCP

- [x] VPC custom, sous-réseaux, Private Google Access
- [x] Cloud Router, Cloud NAT
- [x] Firewall rules, Cloud Armor
- [x] Cloud SQL HA, sauvegardes, Secret Manager
- [x] Cloud Storage, versioning, lifecycle, KMS
- [x] Load Balancer HTTPS, backend, health check, SSL
- [x] Managed Instance Group, template, autoscaling
- [x] IAM, service accounts, rôles, groupes
- [x] Snapshots, backups, monitoring, alertes (partial)
- [x] Monitoring — notification channel created, CPU alert policy created, uptime check created

### 4. Documentation & Schémas

- [ ] Ajouter les diagrammes dans un dossier `docs/` (ex. `docs/schema-infrastructure.png`)
- [ ] Compléter la documentation technique (réseau, sécurité, IAM, sauvegarde) et lier les fichiers dans `docs/`

5. Tests & Validation

- [ ] Mettre en place des tests de déploiement (terraform plan/apply dans un environnement isolé)
- [ ] Tests de sécurité et résilience (WAF, restauration, failover AZ)
- [ ] Monitoring / alertes (configurer CloudWatch + alertes)

---
---

## Schéma d’infrastructure

> Voir le fichier `schema-infrastructure.png` ou ouvrez le diagramme sur draw.io/Lucidchart.

---

## Documentation technique

- Configurations réseau (VPC/VNet, sous-réseaux, routage)
- Sécurité (SG/NSG, WAF, IAM, chiffrement)
- Sauvegarde et reprise (RTO/RPO)
- Monitoring et alertes

---

## Rapport comparatif

- Analyse des services équivalents
- Estimation des coûts
- Complexité de mise en œuvre
- Performances observées
- Recommandations

---

## Notes

- **Full IaC** : Toutes les ressources sont déployées via scripts d’automatisation (Terraform, CloudFormation, Bicep)
- **Suivi** : Cochez chaque étape au fur et à mesure
- **Schémas** : Ajoutez vos diagrammes dans le dossier `/docs` ou en pièce jointe
- **Mise à jour automatique** : la checklist ci‑dessous est tenue à jour au fur et à mesure des actions réalisées.

---

### Remarques opérationnelles

- Un backend temporaire (`tpcloud-temp-mig`) a été créé pour rendre le load balancer immédiatement fonctionnel — il utilise le template contenant le startup-script qui installe nginx. Quand vous êtes prêt, je peux supprimer ce backend et son autoscaler après avoir appliqué une correction durable sur le MIG principal.


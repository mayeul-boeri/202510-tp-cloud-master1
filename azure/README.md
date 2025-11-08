# Azure Terraform Project

## Description
Ce projet déploie une infrastructure complète sur Azure à l’aide de Terraform : réseau, VMSS, Application Gateway (load balancer), Key Vault, stockage, monitoring, sauvegarde, et gestion des identités.

## Prérequis
- Azure CLI configuré
- Terraform >= 1.0
- Un abonnement Azure valide

## Déploiement
1. Clonez le dépôt et placez-vous dans le dossier `azure`.
2. Initialisez Terraform :
   ```bash
   terraform init
   ```
3. Appliquez la configuration :
   ```bash
   terraform apply -var-file="var.tfvars"
   ```
4. Detruire toute les ressource :
    ```bash
    terraform destroy -var-file="var.tfvars"
    ```


## Limitations connues
- **Comptes et groupes Azure AD** : La création automatique d’utilisateurs et de groupes Azure AD échoue avec une souscription Azure Student, car elle ne donne pas les droits nécessaires (erreur 403 Authorization_RequestDenied).
- **Application Gateway (Load Balancer)** : Il peut y avoir un timeout ou un backend not connected, même si tout est bien configuré, à cause de limitations réseau ou de propagation Azure. Vérifiez le backend health dans le portail Azure et assurez-vous que les probes et NSG sont corrects.
- **Key Vault** : Le nom du Key Vault doit être unique globalement. Si une erreur "VaultAlreadyExists" apparaît, changez le nom ou purgez l’ancien vault.


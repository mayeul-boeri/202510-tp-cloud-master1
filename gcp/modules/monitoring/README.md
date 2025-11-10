Module Monitoring — Alerting & Uptime

Description
- Crée un canal de notification (email) et un uptime check dans Stackdriver Monitoring / Cloud Monitoring.

Prérequis
- API Monitoring activée.

Variables d'entrée
- `project_id` (string)
- `notification_email` (string) : adresse email pour les alertes.
- `create_notification_channel` (bool) — défaut `false`.
- `enable_uptime_check` (bool) — défaut `false`.
- `uptime_host` (string) : hôte à vérifier.

Outputs
- Aucun output explicite, mais le module crée les ressources Monitoring nécessaires.

Exemple
module "monitoring" {
  source     = "../modules/monitoring"
  project_id = var.project_id
  notification_email = "ops@example.com"
  create_notification_channel = true
  enable_uptime_check = true
  uptime_host = module.load_balancer.forwarding_rule_ip
}

Notes
- Pour recevoir des emails d'alerte, le canal de notification doit être validé (Stackdriver envoie un mail de confirmation).

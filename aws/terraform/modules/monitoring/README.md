Module Monitoring AWS — CloudWatch Alarms

Description
- Crée des alarmes CloudWatch pour RDS, ASG et autres composants afin d'alerter en cas d'état anormal.

Prérequis
- Permissions CloudWatch et accès aux ressources à surveiller.

Variables d'entrée
- `project_name`, `db_instance_id`, `asg_name`.

Outputs
- `rds_cpu_alarm_name`, `asg_below_min_alarm_name`.

Exemple
module "monitoring" {
  source = "../modules/monitoring"
  project_name = var.project_name
}

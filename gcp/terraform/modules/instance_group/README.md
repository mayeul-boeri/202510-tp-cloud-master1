Module Groupes d'instances — Instance Template & MIG

Description
- Crée un Instance Template et un Managed Instance Group (MIG), zonal ou régional selon la configuration. Supporte le `startup_script`, l'autorepair (auto-healing) et named ports pour intégration avec un backend HTTP(S).

Prérequis
- API Compute activée.

Variables d'entrée (exemples)
- `project_id`, `region`, `zone`.
- `name_prefix` — préfixe pour nommer les ressources.
- `instance_count`, `machine_type`, `source_image`.
- `network_self_link`, `subnetwork_self_link`.
- `startup_script` : script bash injecté dans le template (via metadata startup-script or cloud-init equivalents).
- Autoscaling : `enable_autoscaling`, `autoscaling_min_replicas`, `autoscaling_max_replicas`, `autoscaling_cpu_target`.
- Health checks / auto-healing : `enable_health_check`, `auto_healing_initial_delay`.

Outputs
- `instance_template_self_link` : self_link de l'instance template.
- `mig_self_link` : self_link du MIG (pour regional managers).
- `instance_group_self_link` : self_link utilisable comme backend.

Exemple d'utilisation
module "instance_group" {
  source         = "../modules/instance_group"
  project_id     = var.project_id
  region         = "us-central1"
  startup_script = file("../startup/nginx.sh")
}

Bonnes pratiques
- Configurez un `named_port` (ex. `http:80`) pour que le backend service puisse mapper le `port_name`. Le module gère le mapping des named ports nativement.
- Gardez le startup script idempotent et court ; utilisez des retries pour les opérations réseau.

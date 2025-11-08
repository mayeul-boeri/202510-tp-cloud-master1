Module Auto Scaling Group (ASG)

Description
- Gère un Auto Scaling Group AWS avec un Launch Template et user-data pour configurer les instances.

Prérequis
- Permissions IAM pour créer des Launch Templates, AutoScaling Groups et attacher des Target Groups.

Variables d'entrée
- `project_name`, `instance_ami`, `instance_type`, `web_sg_id`, `user_data`.
- `private_subnet_ids`, `target_group_arns`.
- `asg_min_size`, `asg_max_size`, `asg_desired_capacity`.
- `instance_profile_name`, `health_check_grace_period`.

Outputs
- `asg_name`, `launch_template_id`.

Exemple d'utilisation
module "asg" {
  source = "../modules/asg"
  project_name = var.project_name
}

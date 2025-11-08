Module ALB — Application Load Balancer (AWS)

Description
- Provisionne un Application Load Balancer (ALB) et un Target Group pour servir le trafic HTTP(S) destiné aux instances.

Prérequis
- Permissions EC2/ELB pour créer ALB et target groups.

Variables d'entrée
- `project_name`, `public_subnet_ids`, `web_sg_id`, `vpc_id`.

Outputs
- `alb_dns_name`, `target_group_arn`, `alb_arn`.

Exemple
module "alb" {
  source = "../modules/alb"
  project_name = var.project_name
}

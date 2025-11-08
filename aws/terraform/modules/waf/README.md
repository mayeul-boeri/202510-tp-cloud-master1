Module WAF — Web ACL

Description
- Provisionne une Web ACL AWS WAF et permet l'association à un ALB pour filtrer le trafic HTTP(S).

Prérequis
- Permissions WAF (wafv2) et accès à l'ALB.

Variables d'entrée
- `project_name` (string)
- `alb_arn` (string) — ARN de l'ALB à protéger.

Outputs
- `web_acl_arn`, `web_acl_id`.

Exemple d'utilisation
module "waf" {
  source = "../modules/waf"
  project_name = var.project_name
}

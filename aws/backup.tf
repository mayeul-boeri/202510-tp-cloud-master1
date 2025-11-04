resource "aws_backup_vault" "main" {
  name = "${var.project}-backup-vault"
}

resource "aws_backup_plan" "main" {
  name = "${var.project}-backup-plan"

  rule {
    rule_name         = "daily-backup"
    target_vault_name = aws_backup_vault.main.name
    schedule          = "cron(0 2 * * ? *)" #tous les jours à 2h00 utc
    start_window      = 60
    completion_window = 180
    lifecycle {
      delete_after = 7
    }
    copy_action {
      destination_vault_arn = aws_backup_vault.dr.arn
      lifecycle {
        delete_after = 7
      }
    }
  }
}

resource "aws_backup_vault" "dr" {
  provider = aws.dr
  name     = "${var.project}-backup-vault-dr"
}

resource "aws_backup_selection" "main" {
  name         = "main-selection"
  iam_role_arn = aws_iam_role.backup.arn
  plan_id      = aws_backup_plan.main.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "Backup"
    value = "true"
  }

  resources = [
    aws_db_instance.mysql.arn
    # Ajoute ici manuellement les ARN de volumes EBS ou d'instances EC2 si besoin
    
  ]
}

resource "aws_iam_role" "backup" {
  name = "${var.project}-backup-role"
  assume_role_policy = data.aws_iam_policy_document.backup_assume_role.json
}

data "aws_iam_policy_document" "backup_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "backup" {
  role       = aws_iam_role.backup.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}
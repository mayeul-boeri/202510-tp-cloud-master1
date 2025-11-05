resource "aws_backup_vault" "this" {
  name        = "${var.project_name}-backup-vault"
  kms_key_arn = null
}

resource "aws_backup_plan" "daily" {
  name = "${var.project_name}-daily-backup"

  rule {
    rule_name         = "daily-rule"
    target_vault_name = aws_backup_vault.this.name
    schedule          = "cron(0 5 ? * * *)"
    lifecycle {
      cold_storage_after = 0
      delete_after       = 90
    }
  }
}

resource "aws_iam_role" "backup_role" {
  name = "${var.project_name}-backup-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "backup.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "backup_attach" {
  role       = aws_iam_role.backup_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

locals {
  resources = var.s3_bucket_arn != "" ? [var.db_arn, var.s3_bucket_arn] : [var.db_arn]
}

resource "aws_backup_selection" "selection" {
  name         = "${var.project_name}-selection"
  plan_id      = aws_backup_plan.daily.id
  iam_role_arn = aws_iam_role.backup_role.arn

  resources = local.resources
}

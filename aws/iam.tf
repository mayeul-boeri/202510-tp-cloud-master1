# Rôle IAM pour EC2 avec accès S3, Secrets Manager et CloudWatch
resource "aws_iam_role" "ec2" {
  name = "${var.project}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "s3" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "secrets" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_role_policy_attachment" "cw" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${var.project}-ec2-profile"
  role = aws_iam_role.ec2.name
}

# Exemple d'utilisateur IAM (MFA à activer manuellement)
resource "aws_iam_user" "dev" {
  name = "developer"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "dev" {
  user    = aws_iam_user.dev.name
  password_reset_required = true
}

resource "aws_iam_user_policy_attachment" "dev_readonly" {
  user       = aws_iam_user.dev.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# Groupes IAM (pour IAM Identity Center/SSO, à gérer via la console AWS)
resource "aws_iam_group" "admins" {
  name = "Admins"
}
resource "aws_iam_group" "devs" {
  name = "Developpeurs"
}
resource "aws_iam_group" "readonly" {
  name = "LectureSeule"
}

# Exemple d'attachement d'utilisateur à un groupe
resource "aws_iam_user_group_membership" "dev" {
  user = aws_iam_user.dev.name
  groups = [
    aws_iam_group.devs.name,
    aws_iam_group.readonly.name
  ]
}

data "aws_caller_identity" "current" {}
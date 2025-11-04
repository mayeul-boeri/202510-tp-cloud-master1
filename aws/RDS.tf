resource "aws_db_subnet_group" "rds" {
  name       = "${var.project}-db-subnet-group"
  subnet_ids = [
    aws_subnet.subnets["Private-1A"].id,
    aws_subnet.subnets["Private-1B"].id
  ]
  tags = {
    Name = "${var.project}-db-subnet-group"
  }
}


resource "aws_secretsmanager_secret" "rds" {
  name = var.rds_secret_name
}

resource "aws_secretsmanager_secret_version" "rds" {
  secret_id     = aws_secretsmanager_secret.rds.id
  secret_string = jsonencode({
    username = "admin"
    password = "Password123" 
  })
}

resource "aws_db_instance" "mysql" {
  identifier              = "${var.project}-mysql"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp3"
  storage_encrypted       = true
  multi_az                = true
  db_subnet_group_name    = aws_db_subnet_group.rds.name
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  username                = jsondecode(aws_secretsmanager_secret_version.rds.secret_string)["username"]
  password                = jsondecode(aws_secretsmanager_secret_version.rds.secret_string)["password"]
  backup_retention_period = 7
  skip_final_snapshot     = true

  tags = {
    Name = "${var.project}-mysql"
  }
}
resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

resource "random_password" "db" {
  length  = 16
  special = false
}

resource "aws_db_instance" "mysql" {
  identifier             = "${var.project_name}-mysql"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_allocated_storage
  db_name                = "${var.project_name}db"
  username               = var.db_username
  password               = (var.db_password != null && var.db_password != "") ? var.db_password : random_password.db.result
  storage_encrypted      = true
  multi_az               = true
  skip_final_snapshot    = true
  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.db_sg_id]

  tags = {
    Name = "${var.project_name}-mysql"
  }
}

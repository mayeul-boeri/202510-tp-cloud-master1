
# ALB-SG : autorise HTTP et HTTPS depuis Internet
resource "aws_security_group" "alb_sg" {
  name        = "${var.project}-alb-sg"
  description = "Allow HTTP and HTTPS from anywhere"
  vpc_id      = aws_vpc.tp-vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-alb-sg"
  }
}

# WebServer-SG : autorise HTTP depuis ALB-SG uniquement
resource "aws_security_group" "web_sg" {
  name        = "${var.project}-web-sg"
  description = "Allow HTTP from ALB-SG only"
  vpc_id      = aws_vpc.tp-vpc.id

  ingress {
    description     = "HTTP from ALB-SG"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-web-sg"
  }
}

# Database-SG : autorise MySQL depuis WebServer-SG uniquement
resource "aws_security_group" "db_sg" {
  name        = "${var.project}-db-sg"
  description = "Allow MySQL from WebServer-SG only"
  vpc_id      = aws_vpc.tp-vpc.id

  ingress {
    description     = "MySQL from WebServer-SG"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-db-sg"
  }
}
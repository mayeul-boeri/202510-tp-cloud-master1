resource "aws_launch_template" "web" {
  name_prefix   = "${var.project}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2.name
  }
  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
yum install -y httpd
systemctl enable httpd
systemctl start httpd
echo "<h1>Bienvenue sur $(hostname)</h1>" > /var/www/html/index.html
EOF
  )
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name   = "${var.project}-web"
      Backup = "true"
    }
  }
}

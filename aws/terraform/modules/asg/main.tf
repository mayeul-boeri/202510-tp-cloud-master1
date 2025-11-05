resource "aws_launch_template" "app" {
  name_prefix = "${var.project_name}-lt-"
  image_id               = var.instance_ami != "" ? var.instance_ami : data.aws_ami.al2.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.web_sg_id]

  user_data = base64encode(var.user_data)

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_name}-instance"
    }
  }

  dynamic "iam_instance_profile" {
    for_each = var.instance_profile_name != "" ? [1] : []
    content {
      name = var.instance_profile_name
    }
  }
}

data "aws_ami" "al2" {
  most_recent = true
  owners      = ["137112412989"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name                = "${var.project_name}-asg"
  max_size            = var.asg_max_size
  min_size            = var.asg_min_size
  desired_capacity    = var.asg_desired_capacity
  vpc_zone_identifier = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  target_group_arns = var.target_group_arns

  health_check_type = "ELB"
  health_check_grace_period = var.health_check_grace_period

  tag {
    key                 = "Name"
    value               = "${var.project_name}-asg"
    propagate_at_launch = true
  }
}

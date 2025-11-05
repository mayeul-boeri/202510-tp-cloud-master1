############################################
# Auto Scaling Group attaché à l’ALB
############################################

resource "aws_autoscaling_group" "web" {
  desired_capacity     = 2
  max_size             = 4
  min_size             = 2

  vpc_zone_identifier = [
    aws_subnet.subnets["Private-1A"].id,
    aws_subnet.subnets["Private-1B"].id
  ]

  # Attachement direct au Target Group ALB
  target_group_arns = [aws_lb_target_group.web.arn]

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project}-web"
    propagate_at_launch = true
  }

  depends_on = [aws_lb_target_group.web]
}

############################################
# Scale Out (CPU > 70% pendant 2 minutes)
############################################

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "${var.project}-scale-out"
  autoscaling_group_name = aws_autoscaling_group.web.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 120 # 2 minutes
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.project}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Scale out if CPU > 70% for 2 minutes"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_out.arn]
}

############################################
# Scale In (CPU < 30% pendant 5 minutes)
############################################

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "${var.project}-scale-in"
  autoscaling_group_name = aws_autoscaling_group.web.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 300 # 5 minutes
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "${var.project}-low-cpu"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 5
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 30
  alarm_description   = "Scale in if CPU < 30% for 5 minutes"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_in.arn]
}
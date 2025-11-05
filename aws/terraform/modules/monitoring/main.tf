resource "aws_cloudwatch_metric_alarm" "rds_cpu_high" {
  alarm_name          = "${var.project_name}-rds-cpu-high"
  alarm_description   = "Alarm if RDS CPU > 70% for 5 minutes"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  period              = 60
  threshold           = 70
  statistic           = "Average"
  namespace           = "AWS/RDS"
  metric_name         = "CPUUtilization"

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }

  treat_missing_data = "missing"
}

resource "aws_cloudwatch_metric_alarm" "asg_below_min" {
  alarm_name          = "${var.project_name}-asg-below-min"
  alarm_description   = "Alarm if Auto Scaling Group has fewer than 1 InService instance"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  period              = 60
  threshold           = 1
  statistic           = "Minimum"
  namespace           = "AWS/AutoScaling"
  metric_name         = "GroupInServiceInstances"

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  treat_missing_data = "missing"
}

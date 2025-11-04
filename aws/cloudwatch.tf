resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project}-dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        x = 0
        y = 0
        width = 12
        height = 6
        properties = {
          metrics = [
            [ "AWS/ApplicationELB", "RequestCount", "LoadBalancer", aws_lb.web.arn_suffix ],
            [ ".", "HTTPCode_ELB_5XX_Count", ".", "." ],
            [ ".", "TargetResponseTime", ".", "." ]
          ]
          period = 300
          stat = "Sum"
          region = var.aws_region
          title = "ALB Requests, 5XX, Latency"
        }
      },
      {
        type = "metric"
        x = 12
        y = 0
        width = 12
        height = 6
        properties = {
          metrics = [
            [ "AWS/EC2", "CPUUtilization", "AutoScalingGroupName", aws_autoscaling_group.web.name ],
            [ ".", "NetworkIn", ".", "." ],
            [ ".", "NetworkOut", ".", "." ],
            [ ".", "DiskReadBytes", ".", "." ],
            [ ".", "DiskWriteBytes", ".", "." ]
          ]
          period = 300
          stat = "Average"
          region = var.aws_region
          title = "EC2 Metrics"
        }
      },
      {
        type = "metric"
        x = 0
        y = 6
        width = 12
        height = 6
        properties = {
          metrics = [
            [ "AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", aws_db_instance.mysql.id ],
            [ ".", "DatabaseConnections", ".", "." ],
            [ ".", "ReadIOPS", ".", "." ],
            [ ".", "WriteIOPS", ".", "." ],
            [ ".", "FreeStorageSpace", ".", "." ]
          ]
          period = 300
          stat = "Average"
          region = var.aws_region
          title = "RDS Metrics"
        }
      }
    ]
  })
}

# Alarmes CloudWatch

resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "${var.project}-alb-5xx"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Sum"
  threshold           = 10
  dimensions = {
    LoadBalancer = aws_lb.web.arn_suffix
  }
  alarm_description = "ALB 5XX errors > 10 sur 5 minutes"
}

resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  alarm_name          = "${var.project}-rds-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  dimensions = {
    DBInstanceIdentifier = aws_db_instance.mysql.id
  }
  alarm_description = "RDS CPU > 80% pendant 10 minutes"
}

resource "aws_cloudwatch_metric_alarm" "alb_unhealthy" {
  alarm_name          = "${var.project}-alb-unhealthy"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Average"
  threshold           = 0
  dimensions = {
    TargetGroup  = aws_lb_target_group.web.arn_suffix
    LoadBalancer = aws_lb.web.arn_suffix
  }
  alarm_description = "Unhealthy targets > 0"
}
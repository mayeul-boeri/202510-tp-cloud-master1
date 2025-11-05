output "rds_cpu_alarm_name" {
  value = aws_cloudwatch_metric_alarm.rds_cpu_high.alarm_name
}

output "asg_below_min_alarm_name" {
  value = aws_cloudwatch_metric_alarm.asg_below_min.alarm_name
}

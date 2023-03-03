resource "aws_autoscaling_policy" "magento_backend_policy_up" {
  name = "${var.acemart_prod_owner}-magento-backend-policy-up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.magento_backend_asg.name
}

resource "aws_cloudwatch_metric_alarm" "magento_backend_cpu_alarm_up" {
  alarm_name = "${var.acemart_prod_owner}-magento-backend-cpu-alarm-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "20"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.magento_backend_asg.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.magento_backend_policy_up.arn ]
}

resource "aws_autoscaling_policy" "magento_backend_policy_down" {
  name = "${var.acemart_prod_owner}-magento-backend-policy-down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.magento_backend_asg.name
}

resource "aws_cloudwatch_metric_alarm" "magento_backend_cpu_alarm_down" {
  alarm_name = "${var.acemart_prod_owner}-magento-backend-cpu-alarm-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "10"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.magento_backend_asg.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.magento_backend_policy_down.arn ]
}
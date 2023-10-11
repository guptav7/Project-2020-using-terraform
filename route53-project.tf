resource "aws_route53_record" "www" {
  zone_id = "Z0327180OCGZH0NJCC1C"
  name    = "www"
  type    = "A"

  alias {
    name                   = aws_lb.test.dns_name
    zone_id                = aws_lb.test.zone_id
    evaluate_target_health = true
  }
}

resource "aws_cloudwatch_metric_alarm" "asg-alarm" {
  alarm_name          = "asg-tf-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  #period is the time in seconds
  period              = "60"
  statistic           = "Average"
  #threshold is the percentage
  threshold           = "20"
  datapoints_to_alarm = "1"
  alarm_actions 	  = ["arn:aws:sns:us-east-1:861402827519:ec2-topic"] 
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg-tf.name
  }

  alarm_description = "This metric monitors ec2 cpu tf utilization"
  
}



resource "aws_cloudwatch_event_rule" "app-asg-ec2-launching" {
  name        = "capture_app_autoscaling"
  description = "Capture each app asg ec2 launching success"

  event_pattern = jsonencode({
    source = [
      "aws.autoscaling"
    ],
    detail-type = [
      "EC2 Instance Launch Successful"
    ],
    detail = {
      AutoScalingGroupName = [
        "blue_${var.environment}-app-asg1",
        "blue_${var.environment}-app-asg2r"
    ] }
  })
}

resource "aws_cloudwatch_event_target" "app-autoheal-funcation" {
  arn  = module.lambda_function.lambda_function_arn
  rule = aws_cloudwatch_event_rule.app-asg-ec2-launching.id
}
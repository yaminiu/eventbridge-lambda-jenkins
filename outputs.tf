################################################################################
# Layer
################################################################################

output "reuqest_layer_arn_ver" {
  value = aws_lambda_layer_version.lambda_layer_reuest.arn
}

output "reuqest_layer_arn" {
  value = aws_lambda_layer_version.lambda_layer_reuest.layer_arn
}


# Eventbridge Rule ARN

output "aws_cloudwatch_event_rule_arn" {
  value = aws_cloudwatch_event_rule.app-asg-ec2-launching.arn
}


# # lambda Funcation

output "app_autoheal_lambda_funcation_name" {
  value = module.lambda_function.lambda_function_name
}

output "app_autoheal_lambda_funcation_arn" {
  value = module.lambda_function.lambda_function_arn
}

output "app_autoheal_lambda_funcation_version" {
  value = module.lambda_function.lambda_function_version
}
# output "db_instances_endpoint" {
#   description = "The access endpoint of the db instance"
#   value       = module.db_instance.db_instance_endpoint
# }

# output "db_instance_name" {
#   description = "The database name"
#   value       = try(module.db_instance.db_instance_name, "")
# }

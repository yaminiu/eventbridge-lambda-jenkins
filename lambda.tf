
##########################################
# Create a role for  app autoheal lambda
##########################################
resource "aws_iam_role" "lambda_function_role" {
  name = local.lambda_role_name
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Action : "sts:AssumeRole",
        Effect : "Allow",
        Principal : {
          "Service" : "lambda.amazonaws.com"
        }
      }
    ]
  })
}


resource "aws_iam_policy" "stserver_lambda_policy" {
  name        = local.lambda_policy_name
  description = "app Stserver Lambda Policy"
  policy      = templatefile("templates/lambda_function_policy.json.tpl", { s3_installation_bucket = var.s3_installation_bucket, snsxmateremail = var.snsemail, snsxmatermessage = var.snsmessage, aws_account = var.aws_account_id })
}

resource "aws_iam_role_policy_attachment" "function_logging_policy_attachment" {
  role       = aws_iam_role.lambda_function_role.id
  policy_arn = aws_iam_policy.stserver_lambda_policy.arn
}

resource "aws_cloudwatch_log_group" "function_log_group" {
  name              = "/aws/lambda/${local.lambda_func_name}"
  retention_in_days = 7
  lifecycle {
    prevent_destroy = false
  }
}

##########################################
# request layer for app autoheal lambda
##########################################

resource "aws_lambda_layer_version" "lambda_layer_reuest" {
  # filename   = "lambda_layer_payload.zip"
  layer_name          = "requests_2-31-0"
  s3_bucket           = var.s3_installation_bucket
  s3_key              = "lambda/requests-2.31.0_layer.zip"
  compatible_runtimes = ["python3.10", "python3.11"]
}


##########################################
# Lambda Function (trigger Jenkins Job )
##########################################

module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 5.0"

  function_name = local.lambda_func_name
  description   = "Trigger app autoheal pipeline"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"
  publish       = true
  lambda_role   = aws_iam_role.lambda_function_role.arn

  vpc_subnet_ids         = var.vpc_subnet_ids
  vpc_security_group_ids = var.vpc_security_group_ids

  create_package = false
  create_role    = false
  s3_existing_package = {
    bucket = var.s3_installation_bucket
    key    = "lambda/app_autoheal_lambda_funcation.zip"
  }
  environment_variables = {
    AUTH_TOKEN  = "/app/autoheal/auth/token",
    JENKINS_URL = "/app/${var.environment}/autoheal/url",
    USERNAME    = "/jenkins/username",
    API_TOKEN   = "/jenkins/token"
  }
  allowed_triggers = {
    ScanAmiRule = {
      principal  = "events.amazonaws.com"
      source_arn = aws_cloudwatch_event_rule.app-asg-ec2-launching.arn
    }
  }
  layers = [
    "arn:aws:lambda:ap-southeast-2:665172237481:layer:AWS-Parameters-and-Secrets-Lambda-Extension:11",
    aws_lambda_layer_version.lambda_layer_reuest.arn

  tags = merge(
    {
      "Name" = local.lambda_func_name
    },
    local.tags,
  )
}

resource "aws_lambda_function_event_invoke_config" "lambda_event_invoke_config" {
  function_name = local.lambda_func_name

  destination_config {
    on_failure {
      destination = var.snsmessage
    }
    on_success {
      destination = var.snsemail
    }
  }
  depends_on = [
    module.lambda_function
  ]
}
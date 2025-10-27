
# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach AWS managed policy for basic Lambda execution
resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda function
resource "aws_lambda_function" "example" {
  function_name = "my_lambda_function"
#   filename      = "lambda.zip"
  s3_bucket     = "vihana123"
  s3_key        = "lambda.zip"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  role          = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      ENV = "dev"
    }
  }

  # Optional tags
  tags = {
    Name = "TerraformLambda"
  }
}

# (Optional) — CloudWatch Log Group (for log retention)
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.example.function_name}"
  retention_in_days = 14
}

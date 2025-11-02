# IAM Role
resource "aws_iam_role" "rds_monitoring_role" {
  name = "rds-monitoring-role1"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# AWS IAM Policy

resource "aws_iam_policy" "rds_monitoring_policy" {
  name        = "rds-monitoring-policy"
  description = "Custom policy to allow RDS Enhanced Monitoring to publish metrics"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
          "logs:CreateLogGroup"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attache policy with role
resource "aws_iam_role_policy_attachment" "rds_monitoring_attach" {
  role       = aws_iam_role.rds_monitoring_role.name
  policy_arn = aws_iam_policy.rds_monitoring_policy.arn
}

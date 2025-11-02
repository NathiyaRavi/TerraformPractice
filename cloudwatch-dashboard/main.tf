provider "aws" {
  region = "ap-south-1"
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "ec2_dashboard" {
  dashboard_name = "EC2-CPU-Utilization"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x    = 0,
        y    = 0,
        width  = 12,
        height = 6,
        properties = {
          metrics = [
            [
              "AWS/EC2",            # Namespace
              "CPUUtilization",     # Metric Name
              "InstanceId", "i-0406348fd3097c14d"
            ]
          ],
          period = 300,
          stat   = "Average",
          region = "ap-south-1",
          title  = "EC2 CPU Utilization (%)"
        }
      }
    ]
  })
}

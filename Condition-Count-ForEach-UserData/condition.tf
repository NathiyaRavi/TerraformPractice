resource "aws_s3_bucket" "condition-test" {
  count = length(var.env) == 2 ? 1 :0
  bucket = "vihana1234"
}
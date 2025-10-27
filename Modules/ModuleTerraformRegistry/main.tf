module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"

  instance_type = "t3.micro"
  key_name      = "dev_key"
  subnet_id     = "subnet-0b161b9900dc8ccec"
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
  
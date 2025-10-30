locals {
    name = var.name
    ami = var.ami
    instance_type = var.name
}

resource "aws_instance" "locals" {
  ami = local.ami
  instance_type = local.instance_type
  tags = {
    Name = local.name
  }
}
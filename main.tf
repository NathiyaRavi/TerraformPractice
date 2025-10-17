resource "aws_instance" "name" {
  ami = var.ami
  key_name = var.key_name
  instance_type = var.instance_type
}
resource "aws_instance" "name" {
  ami = var.ami
  key_name = var.key_name
  instance_type = var.instance_type
  vpc_security_group_ids = ["sg-091bd61ec286940d7"]
  tags = {
    Name = "Nathiya Test"
  }
}

resource "aws_s3_bucket" "name" {
  bucket = "terraform-test-nathiya"
}
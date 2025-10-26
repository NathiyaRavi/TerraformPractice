resource "aws_instance" "name" {
  ami = var.ami
  key_name = var.key_name
  instance_type = var.instance_type
  vpc_security_group_ids = ["sg-091bd61ec286940d7"]
  tags = {
    Name = "Nathiya test"
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "terraform-state-lock-dynamo"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
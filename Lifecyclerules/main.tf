resource "aws_instance" "test" {
  instance_type = "t3.micro"
  ami =  "ami-0cf8ec67f4b13b491"
  key_name = "dev_key"
  tags = {
    Name = "Pub"
  }

  lifecycle {
    ignore_changes = [ tags, instance_type ] # ignore the manual changes
    create_before_destroy = true # create the resource first and do the destroy task
    prevent_destroy = false #  If true, Error: Instance cannot be destroyed
  }

}


resource "aws_instance" "import-test" {
  instance_type = "t3.micro"
  ami =  "ami-06fa3f12191aa3337"
  key_name = "dev_key"
  tags = {
    Name = "Pub"
  }
}
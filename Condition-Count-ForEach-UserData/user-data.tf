resource "aws_instance" "user-data" {
  ami = "ami-06fa3f12191aa3337"
  instance_type = "t3.micro" 
  user_data = file("userdata.sh")
    tags = {
    Name = "UserData"
    }
}
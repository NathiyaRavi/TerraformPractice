resource "aws_instance" "name" {
  ami = "ami-06fa3f12191aa3337"
  instance_type = "t3.micro"
 
    tags = {
    
    Name = "dev"
    }
}
resource "aws_instance" "name" {
  ami = "ami-06fa3f12191aa3337"
  key_name = "dev_key"
  instance_type = "t3.micro"
  tags = {
    Name = "Nathiya test"
  }
depends_on = [ aws_s3_bucket.name ]
}

resource "aws_s3_bucket" "name" {
  bucket = "vihanashamitha"
  
}
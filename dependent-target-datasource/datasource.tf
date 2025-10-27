data "aws_security_groups" "sec" {
  filter {
    name = "tag:Name"
    values = [ "test-sec" ]
  }
}

resource "aws_instance" "datasource" {
  ami = "ami-06fa3f12191aa3337"
  key_name = "dev_key"
  instance_type = "t3.micro"
  vpc_security_group_ids = [ data.aws_security_groups.sec.ids[0] ]
  tags = {
    Name = "Nathiya test datasource"
  }

}

resource "aws_s3_bucket" "test" {
  bucket = "vihanashamitha123"
}


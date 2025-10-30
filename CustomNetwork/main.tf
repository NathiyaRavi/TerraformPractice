# VPC Creation
resource "aws_vpc" "dev" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Dev-VPC"
  }
}

# Internet Gateway creation
resource "aws_internet_gateway" "dev" {
  vpc_id = aws_vpc.dev.id
  tags = {
    Name = "dev-ig"
  }
}

# Public Subnet Creation
resource "aws_subnet" "dev_pub" {
  vpc_id = aws_vpc.dev.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "Dev-Subnet-pub"
  }
}

# Private subnet creation
resource "aws_subnet" "dev_private" {
  vpc_id = aws_vpc.dev.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  
  tags = {
    Name = "Dev-Subnet-private"
  }
}

# Route table creation
resource "aws_route_table" "dev" {
  vpc_id = aws_vpc.dev.id
  tags = {
    Name = "Dev_pub_rt"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev.id
  }
}

# Public Subnet association with route table
resource "aws_route_table_association" "dev" {
  route_table_id = aws_route_table.dev.id
  subnet_id = aws_subnet.dev_pub.id
}

# elastic ip
resource "aws_eip" "dev" {
  tags = {
    Name = "dev-eip"
  }
}

# NAT gateway creation
resource "aws_nat_gateway" "dev" {
  subnet_id = aws_subnet.dev_pub.id
  allocation_id = aws_eip.dev.id
  tags = {
    Name = "nat"
  }
}

# Private Route table creation
resource "aws_route_table" "dev_private" {
  vpc_id = aws_vpc.dev.id
  tags = {
    Name = "Dev_private_rt"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.dev.id
  }
}

# NAT gateway with subnet allocation
resource "aws_route_table_association" "dev_private_rt" {
  route_table_id = aws_route_table.dev_private.id
  subnet_id = aws_subnet.dev_private.id
}


# Security group creation
resource "aws_security_group" "dev" {
    name = "dev_sg"
    description = "Allow SSH"
    vpc_id = aws_vpc.dev.id
    ingress {
        cidr_blocks = [ "0.0.0.0/0" ]
        protocol = "tcp"
        from_port = 22
        to_port = 22
    }

    egress {
       cidr_blocks = [ "0.0.0.0/0" ]
       protocol = -1
       from_port = 0
       to_port = 0

    }
}

# Create key pair
# resource "aws_key_pair" "dev" {
# }

# Public Ec2 creation
resource "aws_instance" "dev_pub" {
  ami = "ami-06fa3f12191aa3337"
  instance_type = "t3.micro"
  key_name = "dev_key"
  subnet_id = aws_subnet.dev_pub.id
  associate_public_ip_address = true
  security_groups = [ aws_security_group.dev.id ]
  tags = {
    Name = "dev-pub-instance"
  }
}

# Private Ec2 creation
resource "aws_instance" "dev_private" {
  ami = "ami-06fa3f12191aa3337"
  instance_type = "t3.micro"
  key_name = "dev_key"
  subnet_id = aws_subnet.dev_private.id
  security_groups = [ aws_security_group.dev.id ]
  tags = {
    Name = "dev-private-instance_frontend"
  }
}

# Private Ec2 creation
resource "aws_instance" "dev_private" {
  ami = "ami-06fa3f12191aa3337"
  instance_type = "t3.micro"
  key_name = "dev_key"
  subnet_id = aws_subnet.dev_private.id
  security_groups = [ aws_security_group.dev.id ]
  tags = {
    Name = "dev-private-instance_backend"
  }
}



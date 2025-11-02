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

resource "aws_subnet" "dev_pub-1b" {
  vpc_id = aws_vpc.dev.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "Dev-Subnet-pub-1b"
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

# Private subnet creation
resource "aws_subnet" "dev_private-1b" {
  vpc_id = aws_vpc.dev.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"
  
  tags = {
    Name = "Dev-Subnet-private-1b"
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
    ingress {
        cidr_blocks = [ "0.0.0.0/0" ]
        protocol = "tcp"
        from_port = 443
        to_port = 443
    }
    ingress {
        cidr_blocks = [ "0.0.0.0/0" ]
        protocol = "tcp"
        from_port = 3306
        to_port = 3306
    }
    ingress {
        cidr_blocks = [ "0.0.0.0/0" ]
        protocol = "tcp"
        from_port = 80
        to_port = 80
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
  ami = "ami-02d26659fd82cf299"
  instance_type = "t3.micro"
  key_name = "dev_key"
  subnet_id = aws_subnet.dev_pub.id
  associate_public_ip_address = true
  security_groups = [ aws_security_group.dev.id ]
  tags = {
    Name = "dev-pub-instance"
  }
  lifecycle {
    ignore_changes = [ vpc_security_group_ids, security_groups ]
  }
}

# Private Ec2 creation
resource "aws_instance" "dev_private_fe" {
  ami = "ami-02d26659fd82cf299"
  instance_type = "t3.micro"
  key_name = "dev_key"
  subnet_id = aws_subnet.dev_private.id
  security_groups = [ aws_security_group.dev.id ]
  tags = {
    Name = "dev-private-instance_frontend"
  }
  lifecycle {
    ignore_changes = [ vpc_security_group_ids, security_groups ]
  }
}

# Private Ec2 creation
resource "aws_instance" "dev_private_be" {
  ami = "ami-02d26659fd82cf299"
  instance_type = "t3.micro"
  key_name = "dev_key"
  subnet_id = aws_subnet.dev_private.id
  security_groups = [ aws_security_group.dev.id ]
  tags = {
    Name = "dev-private-instance_backend"
  }
  lifecycle {
    ignore_changes = [ vpc_security_group_ids, security_groups ]
  }
}

#AMI for front end server
 
 #You already have an EC2 instance created manually or via Terraform
data "aws_instance" "frontend" {
  instance_id = aws_instance.dev_private_fe.id
}

# Create AMI from that instance
resource "aws_ami_from_instance" "frontend_ami" {
  name               = "frontend-ami-v1"
  source_instance_id = data.aws_instance.frontend.id
  description        = "AMI with pre-installed frontend app"
}

#AMI for backend end server

data "aws_instance" "backend" {
  instance_id = aws_instance.dev_private_be.id
}
resource "aws_ami_from_instance" "backend_ami" {
  name               = "backend-ami-v1"
  source_instance_id = data.aws_instance.backend.id
  description        = "AMI with pre-installed backend app"
}


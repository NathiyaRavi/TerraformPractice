# db security group
resource "aws_security_group" "multi_sg" {
  name        = "multi-sg"
  description = "Multiple SG"
  vpc_id      = "vpc-02c2d32a6f5d9091c"

#  Loop through the map using for_each
  dynamic "ingress" {
    for_each = var.ingress_rules

    content {
      description = "Allow ${upper(ingress.key)} on port ${ingress.value.port}"
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidrs
    }
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "name" {
  ami = "ami-06fa3f12191aa3337"
  instance_type = "t3.micro"
  security_groups = [ aws_security_group.multi_sg.id ]
}
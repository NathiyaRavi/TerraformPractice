# db security group
resource "aws_security_group" "multi_sg" {
  name        = "multi-sg"
  description = "Multiple SG"
  vpc_id      = "vpc-02c2d32a6f5d9091c"

ingress = [
    for name, rule in var.ingress_rules : {
      description      = "Allow TCP port ${rule.port}"
      from_port        = rule.port
      to_port          = rule.port
      protocol         = "tcp"
      cidr_blocks      = rule.cidrs
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]


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
resource "aws_key_pair" "keypair" {
  key_name = "dev_key1"
  public_key = file("C:/Users/nathiya.ravi.GRANICUSINC/.ssh/id_ed25519.pub")
}

resource "aws_s3_bucket" "s3" {
  bucket = "vihanashami1"
}

# IAM Role to allow EC2 to upload to S3
resource "aws_iam_role" "ec2_role" {
  name = "ec2-s3-upload-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "s3_upload_policy" {
  name = "ec2-s3-upload-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:PutObject"]
      Resource = "*"
    }]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  role = aws_iam_role.ec2_role.name
}

# Security group for SSH + HTTP
resource "aws_security_group" "web_sg" {
  name_prefix = "web-sg-"
  description = "Allow SSH and HTTP"
  ingress {
      description      = "SSH"
      from_port        = 22
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
    }
  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  
}

resource "aws_instance" "dev_private" {
  ami = "ami-06fa3f12191aa3337"
  instance_type = "t3.micro"
  key_name = aws_key_pair.keypair.key_name
  vpc_security_group_ids = [ aws_security_group.web_sg.id ]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  tags = {
    Name = "Null resource Test"
  }


}

resource "null_resource" "nullres" {
  depends_on = [aws_instance.dev_private]
  triggers = {
    instance_id = aws_instance.dev_private.id
  }
  
   provisioner "local-exec" {
    command = <<-EOT
      touch local.txt
      echo "say hi" >> local.txt
    EOT
  }

  provisioner "remote-exec" {
    inline = [
        "sudo yum update -y",
    "sudo yum install -y nginx",
    "sudo systemctl enable nginx",
    "sudo systemctl start nginx",
    "sudo echo '<h1>Deployed with Terraform</h1>' > /usr/share/nginx/html/index.html",
    "sudo aws s3 cp /usr/share/nginx/html/index.html s3://${aws_s3_bucket.s3.bucket}"
    ]

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file("C:/Users/nathiya.ravi.GRANICUSINC/.ssh/id_ed25519")
      host = aws_instance.dev_private.public_ip
    }
  }

  provisioner "file" {
    source = "local.txt"
    destination = "/tmp/local.txt"

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file("C:/Users/nathiya.ravi.GRANICUSINC/.ssh/id_ed25519")
      host = aws_instance.dev_private.public_ip
    }
  }
}

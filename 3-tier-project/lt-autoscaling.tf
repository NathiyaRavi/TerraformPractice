resource "aws_launch_template" "frontend_lt" {
  name_prefix   = "frontend-lt-"
  image_id      = aws_ami_from_instance.frontend_ami.id
  key_name = "dev_key"
  instance_type = "t3.micro"
  network_interfaces {
    security_groups = [aws_security_group.dev.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "frontend-asg-instance"
    }
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    sudo systemctl start apache2
    sudo systemctl enable apache2
  EOF
  )
}

resource "aws_launch_template" "backend_lt" {
  name_prefix   = "backend-lt"
  image_id      = aws_ami_from_instance.backend_ami.id
  key_name = "dev_key"
  instance_type = "t3.micro"
  network_interfaces {
    security_groups = [aws_security_group.dev.id]
  }
  
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "backend-asg-instance"
    }
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    sudo pm2 start index.js --name "backendApi"
    sudo pm2 startup systemd
    sudo pm2 save
  EOF
  )
}

resource "aws_autoscaling_group" "frontend_asg" {
  name                      = "frontend-asg"
  desired_capacity           = 2
  min_size                   = 1
  max_size                   = 2
  health_check_grace_period  = 300
  health_check_type          = "EC2"
  force_delete               = true
  
  vpc_zone_identifier        = [
    aws_subnet.dev_private.id,
    aws_subnet.dev_private-1b.id
  ]

  launch_template {
    id      = aws_launch_template.frontend_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.frontend_tg.arn]

  tag {
    key                 = "Name"
    value               = "frontend-asg"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "backend_asg" {
  name                      = "backend-asg"
  desired_capacity           = 2
  min_size                   = 1
  max_size                   = 2
  health_check_grace_period  = 300
  health_check_type          = "EC2"
  force_delete               = true

  vpc_zone_identifier        = [
    aws_subnet.dev_private.id,
    aws_subnet.dev_private-1b.id
  ]
  

  launch_template {
    id      = aws_launch_template.backend_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.backend_tg.arn]

  tag {
    key                 = "Name"
    value               = "backend-asg"
    propagate_at_launch = true
  }
}


resource "aws_lb_target_group" "frontend_tg" {
  name     = "frontend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.dev.id 

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "frontend-target-group"
  }
}

resource "aws_lb_target_group" "backend_tg" {
  name     = "backend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.dev.id 

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "backend-target-group"
  }
}

resource "aws_lb" "frontend_alb" {
  name               = "frontend-alb"
  internal           = false                     # false = public-facing
  load_balancer_type = "application"
  security_groups    = [aws_security_group.dev.id]
  subnets            = [
    aws_subnet.dev_pub.id,
    aws_subnet.dev_pub-1b.id
  ]

  enable_deletion_protection = false

  tags = {
    Name = "frontend-alb"
  }
}

resource "aws_lb" "backend_alb" {
  name               = "backend-alb"
  internal           = false                     # false = public-facing
  load_balancer_type = "application"
  security_groups    = [aws_security_group.dev.id]
  subnets            = [
    aws_subnet.dev_pub.id,
    aws_subnet.dev_pub-1b.id
  ]

  enable_deletion_protection = false
 
  tags = {
    Name = "backend-alb"
  }
}

resource "aws_lb_listener" "frontend_listener" {
  load_balancer_arn = aws_lb.frontend_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
}

resource "aws_lb_listener" "backend_listener" {
  load_balancer_arn = aws_lb.backend_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }
}





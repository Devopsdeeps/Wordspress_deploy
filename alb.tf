resource "aws_lb" "test_lb" {
  name               = "wordpress-ecs-lb"
  load_balancer_type = "application"
  internal           = false
  subnets            = module.vpc.public_subnets
  tags = {
    "env"       = "dev"
    "createdBy" = "Deepika"
  }
  security_groups = [aws_security_group.lb.id]
}

resource "aws_security_group" "lb" {
  name   = "Allow_lb"
  vpc_id = data.aws_vpc.main.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "All"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "All"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "env"       = "dev"
    "createdBy" = "Deepika"
  }
}

resource "aws_lb_target_group" "lb-target-group" {
  name        = "app-target-group"
  target_type = "instance"
  protocol    = "HTTP"
  port        = "80"
  vpc_id      = data.aws_vpc.main.id
  health_check {
    protocol            = "HTTP"
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 5
    timeout             = 5
    interval            = 30
    matcher             = "200,301,302"
  }
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.test_lb.arn
  protocol          = "HTTP"
  port              = "80"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-target-group.arn
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami*amazon-ecs-optimized"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon", "self"]
}

resource "aws_launch_configuration" "app_lc" {
  name          = "wordpress_lc"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  lifecycle {
    create_before_destroy = "true"
  }
  iam_instance_profile        = aws_iam_instance_profile.ecs_service_role.name
  security_groups             = [aws_security_group.asg-sg.id]
  associate_public_ip_address = "true"
  user_data                   = <<EOF
   #! /bin/bash
   sudo apt-get update
   sudo echo "ECS_CLUSTER=${var.cluster_name}" >> /etc/ecs/ecs.config
   EOF
}

resource "aws_security_group" "asg-sg" {
  name   = "wordpress_sg"
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
    name = "Deepika"
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name                      = "wordpress_app_asg"
  launch_configuration      = aws_launch_configuration.app_lc.name
  max_size                  = 1
  min_size                  = 1
  desired_capacity          = 1
  health_check_type         = "ELB"
  health_check_grace_period = 300
  vpc_zone_identifier       = module.vpc.public_subnets
  target_group_arns         = [aws_lb_target_group.lb-target-group.arn]
  protect_from_scale_in     = true
  lifecycle {
    create_before_destroy = true
  }
}
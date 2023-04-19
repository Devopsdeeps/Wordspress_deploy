resource "aws_ecs_cluster" "wordpress_cluster" {
  name               = var.cluster_name
  capacity_providers = [aws_ecs_capacity_provider.cp_test.name ]
  tags = {
    "env"       = "dev"
    "createdBy" = "Deepika"
  }
}

resource "aws_iam_service_linked_role" "ecs" {
  aws_service_name = "ecs.amazonaws.com"

}

resource "aws_ecs_capacity_provider" "cp_test" {
  name = "capacity-provider-test"
  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.app_asg.arn
    managed_termination_protection = "ENABLED"
    managed_scaling {
      status          = "ENABLED"
      target_capacity = 85
    }
  }
}

data "local_file" "container_def" {
  filename = "${path.module}/container-definitions/container-def.json"
}

resource "aws_ecs_task_definition" "task_definition_test" {
  container_definitions = data.local_file.container_def.content
  family                = "web-family"
  network_mode          = "bridge"
  tags = {
    "env"       = "dev"
    "createdBy" = "Deepika"
  }
}

resource "aws_ecs_service" "service" {
  name            = "web-service"
  cluster         = aws_ecs_cluster.wordpress_cluster.arn
  task_definition = aws_ecs_task_definition.task_definition_test.arn
  desired_count   = 2
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.lb-target-group.arn
    container_name   = "wordpress-devops"
    container_port   = 80
  }
  launch_type = "EC2"
  depends_on  = [aws_lb_listener.lb_listener]
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/frontend-container"
  tags = {
    "env"       = "dev"
    "createdBy" = "Deepika"
  }
}


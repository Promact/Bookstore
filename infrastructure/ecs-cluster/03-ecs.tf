resource "aws_ecs_cluster" "this" {
  name = local.cluster_name
}

resource "aws_ecs_task_definition" "this" {
  family       = "${local.resource_tag_prefix}-task-family"
  requires_compatibilities = ["EC2"]
  
  container_definitions = jsonencode([
    {
      name   = "bookstore-app"
      image  = "846819257656.dkr.ecr.eu-north-1.amazonaws.com/terraform-infra-app:15fd46b4e726f54900673d5e87451b5e1456e9b8"
      cpu = 512
      memory = 1024
      portMappings = [
        {
          containerPort = 80
          hostPort      = 0
          protocol = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "this" {
  name            = "${local.resource_tag_prefix}-ecs-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = local.service_instance_count
  
  launch_type = "EC2"

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
    container_name   = "bookstore-app"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.alb_listener]
}
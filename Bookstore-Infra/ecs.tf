resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project}-cluster"
}

#######################   ECS task for app   #######################

resource "aws_ecs_task_definition" "app_task_definition" {
  family                   = "app"
  requires_compatibilities = ["EC2"]
  container_definitions = jsonencode([
    {
      "name" : "app-container",
      "image" : "app:latest",
      "portMappings" : [
        {
          "containerPort" : 80,
          "hostPort" : 80
        }
      ],
      "memory" : 512,
      "memoryReservation" : 256,
      "dockerLabels" : {
        "image" : "nginx"
      }
    },
  ])
}

resource "aws_ecs_service" "app" {
  name            = "app"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.app_task_definition.arn
  desired_count   = 1
}


#######################   ECS task for auth   #######################



resource "aws_ecs_task_definition" "auth_task_definition" {
  family                   = "auth"
  requires_compatibilities = ["EC2"]
  container_definitions = jsonencode([
    {
      "name" : "auth-container",
      "image" : "auth:latest",
      "portMappings" : [
        {
          "containerPort" : 80,
          "hostPort" : 80
        }
      ],
      "memory" : 512,
      "memoryReservation" : 256,
      "dockerLabels" : {
        "image" : "nginx"
      }
    },
  ])
}

resource "aws_ecs_service" "auth" {
  name            = "auth"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.auth_task_definition.arn
  desired_count   = 1
}



#######################   ECS task for db   #######################



# resource "aws_ecs_task_definition" "db_task_definition" {
#   family                   = "db"
#   requires_compatibilities = ["EC2"]
#   container_definitions = jsonencode([
#     {
#       "name" : "db",
#       "image" : "db:latest",
#       "portMappings" : [
#         {
#           "containerPort" : 80,
#           "hostPort" : 80
#         }
#       ],
#       "memory" : 512,
#       "memoryReservation" : 256,
#       "dockerLabels" : {
#         "image" : "nginx"
#       }
#     },
#   ])
# }
# resource "aws_ecs_service" "db" {
#   name            = "db"
#   cluster         = aws_ecs_cluster.ecs_cluster.id
#   task_definition = aws_ecs_task_definition.db_task_definition.arn
#   desired_count   = 1
# }


#######################   ECS task for migrator   #######################



resource "aws_ecs_task_definition" "migrator_task_definition" {
  family                   = "migrator"
  requires_compatibilities = ["EC2"]
  container_definitions = jsonencode([
    {
      "name" : "migrator",
      "image" : "migrator:latest",
      "portMappings" : [
        {
          "containerPort" : 80,
          "hostPort" : 80
        }
      ],
      "memory" : 512,
      "memoryReservation" : 256,
      "dockerLabels" : {
        "image" : "nginx"
      }
    },
  ])
}

resource "aws_ecs_service" "migrator" {
  name            = "migrator"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.migrator_task_definition.arn
  desired_count   = 1
}


#######################   ECS task for web   #######################

resource "aws_ecs_task_definition" "web_task_definition" {
  family                   = "web"
  requires_compatibilities = ["EC2"]
  container_definitions = jsonencode([
    {
      "name" : "web",
      "image" : "web:latest",
      "portMappings" : [
        {
          "containerPort" : 80,
          "hostPort" : 80
        }
      ],
      "memory" : 512,
      "memoryReservation" : 256,
      "dockerLabels" : {
        "image" : "nginx"
      }
    },
  ])
}

resource "aws_ecs_service" "web" {
  name            = "web"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.web_task_definition.arn
  desired_count   = 1
}
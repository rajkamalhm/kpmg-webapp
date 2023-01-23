/*
Resources created by this file:
1. ECS Cluster
2. ECS task definition
3. ECS service(To dynamically create tasks out of task definition)
*/

# Terraform and provider config
#------------------------------
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
#------------------------------


resource "aws_ecs_cluster" "hn-ecs-cluster" {
  name = "hn-app"
  tags = {
    Name = "hn-app"
  }
}

resource "aws_ecs_task_definition" "hn-ecs-task-def" {
  family = "hn-app"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu = 512 # 0.5 vCPU
  memory = 1024
  container_definitions = <<TASK_DEFINITION
[
   {
      "name":"flask-app",
      "image":"${var.hn_app_image}",
      "essential":true,
      "portMappings":[
         {
            "containerPort":8080,
            "hostPort":8080,
            "protocol":"tcp"
         }
      ],
      "environment":[
         {
            "name":"FLASK_ENV",
            "value":"${var.flask_env}"
         },
         {
            "name":"PORT",
            "value":"${var.flask_app_port}"
         },
      ]
   }
]
TASK_DEFINITION
}

resource "aws_ecs_service" "hn-service" {
  name = "hn-service"
  cluster = aws_ecs_cluster.hn-ecs-cluster.id
  task_definition = aws_ecs_task_definition.hn-ecs-task-def.arn
  desired_count = 2
  launch_type = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.hn-ecs-sg.id]
    subnets = aws_subnet.hn-public-subnets.*.id
    assign_public_ip = true
  }

  load_balancer {
    container_name = "hn-app"
    container_port = var.flask_app_port
    target_group_arn = aws_alb_target_group.hn-target-group.id
  }
}
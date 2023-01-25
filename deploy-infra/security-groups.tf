/*
Resources created by this file:
1. Security Group for accessing the ALB
2. Security Group for accessing the ECS service from the ALB
*/
resource "aws_security_group" "hn-alb-sg" {
  name = "hn-app-alb"
  description = "control access to the application load balancer"
  vpc_id = aws_vpc.hn-vpc.id

  ingress {
    from_port = 80
    protocol = "TCP"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "hn-ecs-sg" {
  name = "hn-app-ecs-from-alb"
  description = "control access to the ecs cluster"
  vpc_id = aws_vpc.hn-vpc.id

  ingress {
    from_port = var.flask_app_port
    protocol = "TCP"
    to_port = var.flask_app_port
    security_groups = [aws_security_group.hn-alb-sg.id]
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

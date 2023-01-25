/*
Resources created by this file:
1. Application Load Balancer
2. Target group for the ALB
3. Listner for the ALB
*/

resource "aws_alb" "hn-alb" {
  load_balancer_type = "application"
  name = "hn-alb"
  subnets = aws_subnet.hn-public-subnets.*.id
  security_groups = [aws_security_group.hn-alb-sg.id]
}

resource "aws_alb_target_group" "hn-target-group" {
  name = "hn-ecs-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.hn-vpc.id
  target_type = "ip"
}

resource "aws_alb_listener" "hn-alb-listener" {
  load_balancer_arn = aws_alb.hn-alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.hn-target-group.arn
    type = "forward"
  }
}


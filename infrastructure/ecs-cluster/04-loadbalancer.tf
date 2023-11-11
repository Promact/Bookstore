
resource "aws_lb" "ecs_alb" {
  name               = "${local.resource_tag_prefix}-ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = aws_subnet.public.*.id
}


resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "ecs_target_group" {
  name        = "${local.resource_tag_prefix}-ecs-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.this.id
  target_type = "instance"
  health_check {
    path     = "/"
    protocol = "HTTP"
  }
}


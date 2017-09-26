resource "aws_alb_target_group" "app" {
  name     = "ecs-app"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.myvpc.id}"

  health_check = {
    path    = "/health"
    matcher = 200
  }
}

resource "aws_alb" "alb-ecs-app" {
  name            = "alb-ecs-app"
  subnets         = ["${aws_subnet.mysubnet.*.id}"]
  security_groups = ["${aws_security_group.lb_sg.id}"]
}

resource "aws_alb_listener" "app_front_end" {
  load_balancer_arn = "${aws_alb.alb-ecs-app.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.app.id}"
    type             = "forward"
  }
}

output "alb_hostname" {
  value = "${aws_alb.alb-ecs-app.dns_name}"
}

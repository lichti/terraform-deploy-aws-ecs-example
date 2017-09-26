data "template_file" "myapp" {
  template = "${file("${path.module}/aws_ecs_myapp_task.json")}"

  vars {
    image_url        = "${aws_ecr_repository.myapp.repository_url}"
    container_name   = "myapp"
    log_group_region = "${var.aws_region}"
    token            = "${var.token}"
    log_group_name   = "${aws_cloudwatch_log_group.app.name}"
  }
}

resource "aws_ecs_task_definition" "myapp" {
  family                = "myapp_task"
  container_definitions = "${data.template_file.myapp.rendered}"

  provisioner "local-exec" {
    command     = "sed -e \"s|{{image_url}}|${aws_ecr_repository.myapp.repository_url}|g\" -e \"s|{{TOKEN}}|${var.token}|g\"   docker-compose.yml.tpl > ${path.module}/../app/docker-compose.tmp.yml"
    interpreter = ["bash", "-c"]
  }

  provisioner "local-exec" {
    command     = "docker-compose -f ${path.module}/../app/docker-compose.tmp.yml build"
    interpreter = ["bash", "-c"]
  }

  provisioner "local-exec" {
    command     = "docker-compose -f ${path.module}/../app/docker-compose.tmp.yml push"
    interpreter = ["bash", "-c"]
  }

  provisioner "local-exec" {
    command     = "rm ${path.module}/../app/docker-compose.tmp.yml"
    interpreter = ["bash", "-c"]
  }

  depends_on = [
    "aws_ecr_repository.myapp",
    "aws_ecr_repository_policy.myapp",
  ]
}

resource "aws_ecs_service" "myapp" {
  name            = "myapp_ecs_service"
  cluster         = "${aws_ecs_cluster.mycluster.id}"
  task_definition = "${aws_ecs_task_definition.myapp.arn}"
  desired_count   = 1
  iam_role        = "${aws_iam_role.ecs_service.name}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.app.id}"
    container_name   = "myapp"
    container_port   = "80"
  }

  depends_on = [
    "aws_iam_role_policy.ecs_service",
    "aws_alb_listener.app_front_end",
  ]
}

output "myapp_task_revision" {
  value = "${aws_ecs_task_definition.myapp.revision}"
}

output "myapp_task_status" {
  value = "${aws_ecs_task_definition.myapp.status}"
}

output "myapp_service_desired_count" {
  value = "${aws_ecs_service.myapp.desired_count}"
}

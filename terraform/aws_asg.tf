data "aws_ami" "coreos" {
  most_recent = true

  filter {
    name   = "description"
    values = ["CoreOS stable *"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["595879546273"]
}

data "template_file" "cloud_config" {
  template = "${file("${path.module}/aws_asg_cloud_config.yml")}"

  vars {
    aws_region         = "${var.aws_region}"
    ecs_cluster_name   = "${aws_ecs_cluster.mycluster.name}"
    ecs_log_level      = "info"
    ecs_agent_version  = "latest"
    ecs_log_group_name = "${aws_cloudwatch_log_group.ecs.name}"
  }
}

resource "aws_launch_configuration" "ecs_instance" {
  security_groups = [
    "${aws_security_group.instance_sg.id}",
  ]

  key_name                    = "${aws_key_pair.admin_key.key_name}"
  image_id                    = "${data.aws_ami.coreos.id}"
  instance_type               = "${var.instance_type}"
  iam_instance_profile        = "${aws_iam_instance_profile.ecs_instance.name}"
  user_data                   = "${data.template_file.cloud_config.rendered}"
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app" {
  name                 = "app-asg"
  vpc_zone_identifier  = ["${aws_subnet.mysubnet.*.id}"]
  min_size             = "${var.asg_min}"
  max_size             = "${var.asg_max}"
  desired_capacity     = "${var.asg_desired}"
  launch_configuration = "${aws_launch_configuration.ecs_instance.name}"
}

output "asg_id" {
  value = "${aws_autoscaling_group.app.id}"
}

output "asg_launch_configuration" {
  value = "${aws_launch_configuration.ecs_instance.id}"
}

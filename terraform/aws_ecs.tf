resource "aws_ecs_cluster" "mycluster" {
  name = "my-ecs-cluster"
}

output "ecs_cluster_name" {
  value = "${aws_ecs_cluster.mycluster.name}"
}

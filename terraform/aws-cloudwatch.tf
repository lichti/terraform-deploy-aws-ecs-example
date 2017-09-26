resource "aws_cloudwatch_log_group" "ecs" {
  name = "ecs-group/ecs-agent"
}

resource "aws_cloudwatch_log_group" "app" {
  name = "ecs-group/app"
}

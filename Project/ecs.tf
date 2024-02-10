resource "aws_ecs_cluster" "my_cluster" {
  name = "my-batchfifteencluster-tf"
}


resource "aws_ecs_service" "example_service" {
  name            = "mysvc"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.flaskapp_task_def.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.ecs_security_group.id]
    subnets         = [aws_subnet.subnet1.id]
    assign_public_ip = true
  }
}

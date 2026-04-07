resource "aws_ecs_task_definition" "app_tf" {
  family                   = var.cluster_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.tf_cpu
  memory                   = var.tf_memory
  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  container_definitions = jsonencode([
    {
      name  = "app"
      image = "${var.docker_image}:latest"

      portMappings = [
        {
          containerPort = 8080
        }
      ]
      # CLOUDWATCH LOGGING
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.cluster_name}"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}
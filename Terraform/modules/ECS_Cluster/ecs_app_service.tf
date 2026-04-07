# ECS SERVICE
# Runs the container inside private subnet

resource "aws_ecs_service" "app" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.app_tf.arn
  launch_type     = "FARGATE"

  # Number of running containers
  desired_count = 1

  # ROLLING DEPLOYMENT
  deployment_maximum_percent = 200
  deployment_minimum_healthy_percent = 50
  force_new_deployment = true
  health_check_grace_period_seconds = 60

  # Networking (private subnet)
  network_configuration {
    subnets         = var.private_subnets
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  # Attach to ALB target group
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "app"
    container_port   = 8080
  }
}


# ECS SECURITY GROUP
resource "aws_security_group" "ecs_sg" {
    name = var.srv_sg_name
    description = var.srv_sg_description
    vpc_id = var.core_network

    # No ingress here (handled via ALB SG rule)

    # Allow outbound traffic
    dynamic "egress" {
        for_each = var.ecs_egress
        content {
          description = egress.value.description
          protocol = egress.value.protocol
          cidr_blocks = egress.value.cidr_block
          to_port = egress.value.port
          from_port = egress.value.port
        }
    }
    tags = var.ecs_sg
}
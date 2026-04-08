# REGION + VPC

app_region = "ap-south-1"

cidr_block = "10.0.0.0/16"

vpc_name = {
  Name = "core_vpc"
}

ig = {
  Name = "simple-igw"
}


# PUBLIC SUBNETS
pub_count      = 2
pub_name       = "public-subnet"
pub_cidr_block = ["10.0.1.0/24", "10.0.2.0/24"]


# PRIVATE SUBNETS
pri_count      = 2
pri_name       = "private-subnet"
pri_cidr_block = ["10.0.3.0/24", "10.0.4.0/24"]


# ROUTE TABLES
pub_rt = {
  Name = "public-rt"
}

pri_rt = {
  Name = "private-rt"
}

# ALB CONFIG

alb_name = "app_alb"

alb_sg_name        = "alb-sg"
alb_sg_description = "ALB Security Group"

alb_sg = {
  Name = "alb-sg"
}

alb_tg_name = "app_-tg"

alb_ingress = {
  http = {
    description = "HTTP"
    cidr_block  = ["0.0.0.0/0"]
    protocol    = "tcp"
    port        = 80
  }

  https = {
    description = "HTTPS"
    cidr_block  = ["0.0.0.0/0"]
    protocol    = "tcp"
    port        = 443
  }
}

# ECS CONFIG
cluster_name = "simple-time-cluster"

tf_cpu    = "256"
tf_memory = "512"

docker_image = "varunsimha/simple-time-service"

service_name = "simple-time-service"

srv_sg_name        = "ecs-sg"
srv_sg_description = "ECS Security Group"

ecs_sg = {
  Name = "ecs-sg"
}

ecs_egress = {
  all = {
    description = "Allow all outbound"
    cidr_block  = ["0.0.0.0/0"]
    protocol    = "-1"
    port        = 0
  }
}




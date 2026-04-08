# ROOT MODULE
# This file orchestrates all modules:

# VPC + NETWORKING
# Creates VPC, subnets, route tables, NAT gateway
module "core_vpc" {
    source = "./modules/networking"

    # VPC configuration
    vpc_name = var.vpc_name
    cidr_block = var.cidr_block

    # Public subnets
    pub_name = var.pub_name
    pub_cidr_block = var.pub_cidr_block
    pub_count = var.pub_count

    # Internet and NAT Gateway
    ig = var.ig
    nat = var.nat

    # Public route table
    pub_rt = var.pub_rt

    # Private subnets
    pri_name = var.pri_name
    pri_cidr_block = var.pri_cidr_block
    pri_count = var.pri_count

    # Private route table
    pri_rt = var.pri_rt    
}

# DNS + SSL (Route53 + ACM)
# Creates hosted zone + SSL certificate
module "dns" {
  source = "./modules/route53_acm"
  domain_name = var.domain_name
}

# APPLICATION LOAD BALANCER
# Public entry point for traffic
module "alb" {
    source = "./modules/app_alb"
    depends_on = [ module.core_vpc ]

    public_subnets = module.core_vpc.pub_subnet
    core_network = module.core_vpc.core_network
    certificate_arn = module.dns.certificate_arn

    alb_name = var.alb_name
    alb_tg_name = var.alb_tg_name
    alb_sg_description = var.alb_sg_description
    alb_sg_name = var.alb_sg_name
    alb_sg = var.alb_sg
    alb_ingress = var.alb_ingress 
}

# ECS APPLICATION
# Runs container in private subnet
module "app_ecs" {
    source = "./modules/ECS_Cluster"
    depends_on = [ module.core_vpc, module.alb, module.dns ]

    core_network = module.core_vpc.core_network
    private_subnets = module.core_vpc.pri_subnet
    target_group_arn = module.alb.target_group_arn

    cluster_name = var.cluster_name
    region = var.app_region
    tf_cpu = var.tf_cpu
    tf_memory = var.tf_memory
    docker_image = var.docker_image
    service_name = var.service_name
    
    srv_sg_description = var.srv_sg_description
    srv_sg_name = var.srv_sg_name
    ecs_sg = var.ecs_sg
    ecs_egress = var.ecs_egress
}


#Connecting SGs between ALB and ECS SGs
# ALB → ECS
resource "aws_security_group_rule" "alb_to_ecs" {
  type                     = "egress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.alb.alb_sg
  source_security_group_id = module.app_ecs.ecs_sg
}

# ECS ← ALB
resource "aws_security_group_rule" "ecs_from_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.app_ecs.ecs_sg
  source_security_group_id = module.alb.alb_sg
}

#Updating the DNS record to point to ALB
resource "aws_route53_record" "alb_record" {
  zone_id = module.dns.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = module.alb.alb_dns
    zone_id                = module.alb.alb_zone_id
    evaluate_target_health = true
  }

  depends_on = [module.alb]
}
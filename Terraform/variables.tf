#App hosted Region
variable "app_region" {
    type = string
}

# VPC + NETWORKING
# Creates VPC, subnets, route tables, NAT gateway
variable "cidr_block" {
  type = string
}

variable "vpc_name" {
    type = map(string)
}

variable "ig" {
    type = map(string)
  
}

variable "pub_count" {
  type = number
}

variable "pub_name" {
  type = string
}

variable "pub_cidr_block" {
  type = list(string)
}

variable "pri_cidr_block" {
    type = list(string)
}

variable "pri_name" {
    type = string
}

variable "pri_count" {
  type = number
}

variable "pub_rt" {
  type = map(string)
}

variable "pri_rt" {
    type = map(string)
  
}

# APPLICATION LOAD BALANCER
variable "alb_name" {
    type = string
}

variable "public_subnets" {
    type = list(string)
}

variable "alb_sg_name" {
    type = string
}

variable "alb_sg_description" {
    type = string
}

variable "alb_sg" {
  type = map(string)
}

variable "alb_tg_name" {
  type = string
}

variable "certificate_arn" {
  type = string
}

variable "alb_egress" {
  type = map(object({
    description = string
    cidr_block = list(string)
    protocol = string
    port = number
  }))
}



# ECS APPLICATION
variable "cluster_name" {
  type = string
}

variable "tf_cpu" {
  type = string
}

variable "tf_memory" {
  type = string
}

variable "docker_image" {
  type = string
}

variable "service_name" {
  type = string
}

variable "private_subnets" {
    type = list(string)
}

variable "srv_sg_name" {
    type = string
}

variable "srv_sg_description" {
    type = string
}

variable "ecs_sg" {
  type = map(string)
}

variable "ecs_egress" {
  type = map(object({
    description = string
    cidr_block = list(string)
    protocol = string
    port = number
  }))
}


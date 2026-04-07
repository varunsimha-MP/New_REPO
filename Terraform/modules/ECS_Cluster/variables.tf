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

variable "region" {
  type = string
}

variable "service_name" {
  type = string
}

variable "private_subnets" {
    type = list(string)
}

variable "target_group_arn" {
    type = string
}

variable "srv_sg_name" {
    type = string
}

variable "srv_sg_description" {
    type = string
}

variable "core_network" {
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

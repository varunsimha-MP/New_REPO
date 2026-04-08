# VPC CREATION
resource "aws_vpc" "core_network" {
    cidr_block = var.cidr_block
    instance_tenancy = "default"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = var.vpc_name
}

# PUBLIC SUBNETS
resource "aws_subnet" "pub_subnet" {
    count = var.pub_count
    vpc_id = aws_vpc.core_network.id
    map_public_ip_on_launch = true
    availability_zone = local.azs[count.index]
    cidr_block = var.pub_cidr_block[count.index]
    tags = {
        Name = "${var.pub_name}-${count.index}"
    }
}

# INTERNET GATEWAY
resource "aws_internet_gateway" "app_internet" {
  vpc_id = aws_vpc.core_network.id
  tags = var.ig
}


resource "aws_route_table" "pub_rt" {
    vpc_id = aws_vpc.core_network.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.app_internet.id
    }
    tags = var.pub_rt
}

resource "aws_route_table_association" "pub_rt_association" {
    count = var.pub_count
    route_table_id = aws_route_table.pub_rt.id
    subnet_id = aws_subnet.pub_subnet[count.index].id  
}

# PRIVATE SUBNETS
resource "aws_subnet" "pri_subnet" {
    count = var.pri_count
    vpc_id = aws_vpc.core_network.id
    availability_zone = local.azs[count.index]
    cidr_block = var.pri_cidr_block[count.index]
    tags = {
        Name = "${var.pri_name}-${count.index}"
    }
}

# NAT GATEWAY
resource "aws_eip" "nat" {
    count = var.pub_count
    domain = "vpc"
}

resource "aws_nat_gateway" "app_nat" {
    count = var.pub_count
    allocation_id = aws_eip.nat[count.index].id
    subnet_id = aws_subnet.pub_subnet[count.index].id
    tags = {
    Name = "natgatway-${count.index}"
  }
}

resource "aws_route_table" "pri_rt" {
    vpc_id = aws_vpc.core_network.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.app_nat[0].id
    }
    tags = var.pri_rt
}

resource "aws_route_table_association" "pri_rt_association" {
    count = var.pri_count
    route_table_id = aws_route_table.pri_rt.id
    subnet_id = aws_subnet.pri_subnet[count.index].id
}

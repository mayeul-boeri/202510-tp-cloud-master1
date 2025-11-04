resource "aws_vpc" "tp-vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project}-vpc"
  }
}

resource "aws_subnet" "subnets" {
  for_each                  = { for subnet in var.subnets : subnet.name => subnet }
  vpc_id                    = aws_vpc.tp-vpc.id
  cidr_block                = each.value.cidr
  availability_zone         = each.value.zone
  map_public_ip_on_launch   = each.value.type == "public" ? true : false
  tags = {
    Name = each.value.name
  }
}

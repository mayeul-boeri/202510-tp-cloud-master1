terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

  cidr_block              = "10.0.1.0/24"
  cidr_block              = "10.0.1.0/24"
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "tp_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "TP-VPC"
  }
}

resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.tp_vpc.id
  cidr_block              = "10.0.1.0/24"
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {fdf
    Name = "Public-1A"
  }
}

resource "aws_subnet" "public_1b" {
  vpc_id                  = aws_vpc.tp_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public-1B"
  }
}

resource "aws_subnet" "private_1a" {
  vpc_id            = aws_vpc.tp_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Private-1A"
  }
}

resource "aws_subnet" "private_1b" {
  vpc_id            = aws_vpc.tp_vpc.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "Private-1B"
  }
}

resource "aws_internet_gateway" "tp_igw" {
  vpc_id = aws_vpc.tp_vpc.id
  tags = {
    Name = "TP-IGW"
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "tp_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_1a.id
  tags = {
    Name = "TP-NAT-Gateway"
  }
}

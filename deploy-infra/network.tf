/********
Resources created by this file:
1. VPC
2. Internet Gateway
3. Route Table
4. Public & Private Subnets
5. Security Groups

*********/

# AZs in us-east-1 (as per our provider config)
# There are 6 AZs in us-east-1 at the time of writing this file
data "aws_availability_zones" "azs" {}

resource "aws_vpc" "hn-vpc" {
  cidr_block            = var.vpc_cidr
  enable_dns_hostnames  = true
  enable_dns_support    = true

  tags = {
    Name = "hn-vpc"
  }
}

resource "aws_internet_gateway" "hn-igw" {
  vpc_id = aws_vpc.hn-vpc.id

  tags = {
    Name = "hn-igw"
  }
}

resource "aws_route_table" "hn-rt-public" {
  vpc_id = aws_vpc.hn-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hn-igw.id
  }

  tags = {
    Name = "hn-rt-public"
  }
}

resource "aws_subnet" "hn-public-subnets" {
  count = 4   # 6 available
  cidr_block = var.public_cidrs[count.index]
  vpc_id = aws_vpc.hn-vpc.id
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.azs.names[count.index]

  tags = {
    Name = "hn-tf-public-${count.index + 1}"
  }
}

resource "aws_route_table_association" "fp-public-rt-assc" {
  count = 4
  route_table_id = aws_route_table.hn-rt-public.id
  subnet_id = aws_subnet.hn-public-subnets.*.id[count.index]
}
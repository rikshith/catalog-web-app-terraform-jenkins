resource "aws_vpc" "this" {
  #checkov:skip=CKV2_AWS_11:VPC flow logs add CloudWatch storage costs; app CPU and ALB errors are monitored in this lab.
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name}-vpc"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-igw"
  }
}

resource "aws_subnet" "public" {
  for_each = {
    for index, cidr in var.public_subnet_cidrs : tostring(index) => cidr
  }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  availability_zone       = var.availability_zones[tonumber(each.key)]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.name}-public-${var.availability_zones[tonumber(each.key)]}"
    Tier = "public"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.name}-public"
  }
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.name}-nat-eip"
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public["0"].id

  depends_on = [aws_internet_gateway.this]

  tags = {
    Name = "${var.name}-nat"
  }
}

resource "aws_subnet" "app" {
  for_each = {
    for index, cidr in var.app_subnet_cidrs : tostring(index) => cidr
  }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = var.availability_zones[tonumber(each.key)]

  tags = {
    Name = "${var.name}-app-${var.availability_zones[tonumber(each.key)]}"
    Tier = "private-app"
  }
}

resource "aws_route_table" "app" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = {
    Name = "${var.name}-app"
  }
}

resource "aws_route_table_association" "app" {
  for_each = aws_subnet.app

  subnet_id      = each.value.id
  route_table_id = aws_route_table.app.id
}

resource "aws_subnet" "database" {
  for_each = {
    for index, cidr in var.database_subnet_cidrs : tostring(index) => cidr
  }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = var.availability_zones[tonumber(each.key)]

  tags = {
    Name = "${var.name}-database-${var.availability_zones[tonumber(each.key)]}"
    Tier = "private-database"
  }
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-database"
  }
}

resource "aws_route_table_association" "database" {
  for_each = aws_subnet.database

  subnet_id      = each.value.id
  route_table_id = aws_route_table.database.id
}

resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-default-sg"
  }
}
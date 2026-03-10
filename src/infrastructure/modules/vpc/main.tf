data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  az_subnet_config = {
    a = {
      az_index     = 0
      public_cidr  = var.public_subnet_cidr_a
      private_cidr = var.private_subnet_cidr_a
    }
    b = {
      az_index     = 1
      public_cidr  = var.public_subnet_cidr_b
      private_cidr = var.private_subnet_cidr_b
    }
  }
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.app_name}-vpc"
  }
}

resource "aws_subnet" "public" {
  for_each = local.az_subnet_config

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.public_cidr
  availability_zone       = data.aws_availability_zones.available.names[each.value.az_index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.app_name}-public-${each.key}"
  }
}

resource "aws_subnet" "private" {
  for_each = local.az_subnet_config

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.private_cidr
  availability_zone = data.aws_availability_zones.available.names[each.value.az_index]

  tags = {
    Name = "${var.app_name}-private-${each.key}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.app_name}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.app_name}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  for_each = local.az_subnet_config

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  for_each = local.az_subnet_config

  domain = "vpc"

  tags = {
    Name = "${var.app_name}-nat-${each.key}-eip"
  }
}

resource "aws_nat_gateway" "main" {
  for_each = local.az_subnet_config

  subnet_id     = aws_subnet.public[each.key].id
  allocation_id = aws_eip.nat[each.key].id

  depends_on = [aws_internet_gateway.main]

  tags = {
    Name = "${var.app_name}-nat-${each.key}"
  }
}

resource "aws_route_table" "private" {
  for_each = local.az_subnet_config

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[each.key].id
  }

  tags = {
    Name = "${var.app_name}-private-${each.key}-rt"
  }
}

resource "aws_route_table_association" "private" {
  for_each = local.az_subnet_config

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}

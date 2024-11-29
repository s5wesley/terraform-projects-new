# Create the VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.common_tags,
    {
      "Name" = format(
        "%s-%s-%s-vpc",
        var.common_tags["id"],
        var.common_tags["environment"],
        var.common_tags["owner"]
      )
    }
  )
}

# Public Subnets
resource "aws_subnet" "public" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = element(var.public_azs, count.index)
  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    {
      "Name" = format(
        "%s-%s-%s-public-subnet-%d",
        var.common_tags["id"],
        var.common_tags["environment"],
        var.common_tags["owner"],
        count.index + 1
      )
    }
  )
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = var.private_subnet_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.private_azs, count.index)

  tags = merge(
    var.common_tags,
    {
      "Name" = format(
        "%s-%s-%s-private-subnet-%d",
        var.common_tags["id"],
        var.common_tags["environment"],
        var.common_tags["owner"],
        count.index + 1
      )
    }
  )
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    {
      "Name" = format(
        "%s-%s-%s-igw",
        var.common_tags["id"],
        var.common_tags["environment"],
        var.common_tags["owner"]
      )
    }
  )
}

# NAT Gateway
resource "aws_eip" "nat" {
  count = var.public_subnet_count

  tags = merge(
    var.common_tags,
    {
      "Name" = format(
        "%s-%s-%s-nat-eip-%d",
        var.common_tags["id"],
        var.common_tags["environment"],
        var.common_tags["owner"],
        count.index + 1
      )
    }
  )
}

resource "aws_nat_gateway" "nat" {
  count         = var.public_subnet_count
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    var.common_tags,
    {
      "Name" = format(
        "%s-%s-%s-nat-gateway-%d",
        var.common_tags["id"],
        var.common_tags["environment"],
        var.common_tags["owner"],
        count.index + 1
      )
    }
  )
}

# Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    {
      "Name" = format(
        "%s-%s-%s-public-rt",
        var.common_tags["id"],
        var.common_tags["environment"],
        var.common_tags["owner"]
      )
    }
  )
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Route Table for Private Subnets
resource "aws_route_table" "private" {
  count  = var.private_subnet_count
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    {
      "Name" = format(
        "%s-%s-%s-private-rt-%d",
        var.common_tags["id"],
        var.common_tags["environment"],
        var.common_tags["owner"],
        count.index + 1
      )
    }
  )
}

resource "aws_route" "private" {
  count                  = var.private_subnet_count
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[count.index].id
}

resource "aws_route_table_association" "private" {
  count          = var.private_subnet_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

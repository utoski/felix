# Internet VPC
resource "aws_vpc" "main1" {
  cidr_block           =  var.cidr_block[0]
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "main"
  }
}

# Subnets
resource "aws_subnet" "main-public-11" {
  vpc_id                  = aws_vpc.main1.id
  cidr_block              = var.cidr_block[1]
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "main-public-1"
  }
}

resource "aws_subnet" "main-public-21" {
  vpc_id                  = aws_vpc.main1.id
  cidr_block              = var.cidr_block[2]
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "main-public-21"
  }
}

resource "aws_subnet" "main-public-31" {
  vpc_id                  = aws_vpc.main1.id
  cidr_block              = var.cidr_block[3]
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1c"

  tags = {
    Name = "main-public-3"
  }
}

resource "aws_subnet" "main-private-a" {
  vpc_id                  = aws_vpc.main1.id
  cidr_block              = var.cidr_block[4]
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "main-private-a"
  }
}

resource "aws_subnet" "main-private-b" {
  vpc_id                  = aws_vpc.main1.id
  cidr_block              = var.cidr_block[5]
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "main-private-b"
  }
}

resource "aws_subnet" "main-private-c" {
  vpc_id                  = aws_vpc.main1.id
  cidr_block              = var.cidr_block[6]
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1c"

  tags = {
    Name = "main-private-c"
  }
}

# Internet GW
resource "aws_internet_gateway" "themain-gw" {
  vpc_id = aws_vpc.main1.id

  tags = {
    Name = "main"
  }
}

# route tables
resource "aws_route_table" "public1" {
  vpc_id = aws_vpc.main1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.themain-gw.id
  }

  tags = {
    Name = "main-public-1"
  }
}

# route associations public
resource "aws_route_table_association" "rt-public-1-z" {
  subnet_id      = aws_subnet.main-public-11.id
  route_table_id = aws_route_table.public1.id
}

resource "aws_route_table_association" "rt-public-2-y" {
  subnet_id      = aws_subnet.main-public-21.id
  route_table_id = aws_route_table.public1.id
}

resource "aws_route_table_association" "rt-public-3-a" {
  subnet_id      = aws_subnet.main-public-31.id
  route_table_id = aws_route_table.public1.id
}

resource "aws_route_table" "private21" {
  vpc_id = aws_vpc.main1.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gway.id
  }

  tags = {
    Name = "private-21"
  }
}

# route associations private
resource "aws_route_table_association" "private-1-z" {
  subnet_id      = aws_subnet.main-private-a.id
  route_table_id = aws_route_table.private21.id
}

resource "aws_route_table_association" "private-2-y" {
  subnet_id      = aws_subnet.main-private-b.id
  route_table_id = aws_route_table.private21.id
}

resource "aws_route_table_association" "private-3-a" {
  subnet_id      = aws_subnet.main-private-c.id
  route_table_id = aws_route_table.private21.id
}

# nat gw
resource "aws_eip" "nat-gateway" {
  vpc = true
}

resource "aws_nat_gateway" "nat-gway" {
  allocation_id = aws_eip.nat-gateway.id
  subnet_id     = aws_subnet.main-public-11.id
  depends_on    = [aws_internet_gateway.themain-gw]
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "cloudbite" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "cloudbite-vpc"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.cloudbite.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name                                      = "cloudbite-public-1"
    "kubernetes.io/cluster/cloudbite-cluster" = "shared"
    "kubernetes.io/role/elb"                  = "1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.cloudbite.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name                                      = "cloudbite-public-2"
    "kubernetes.io/cluster/cloudbite-cluster" = "shared"
    "kubernetes.io/role/elb"                  = "1"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.cloudbite.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name                                      = "cloudbite-private-1"
    "kubernetes.io/cluster/cloudbite-cluster" = "shared"
    "kubernetes.io/role/internal-elb"         = "1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.cloudbite.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name                                      = "cloudbite-private-2"
    "kubernetes.io/cluster/cloudbite-cluster" = "shared"
    "kubernetes.io/role/internal-elb"         = "1"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.cloudbite.id

  tags = {
    Name = "cloudbite-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.cloudbite.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "cloudbite-public-rt"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "cloudbite-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id

  subnet_id = aws_subnet.public_1.id

  tags = {
    Name = "cloudbite-nat"
  }

  depends_on = [
    aws_internet_gateway.igw
  ]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.cloudbite.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "cloudbite-private-rt"
  }
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}

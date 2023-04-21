###
### VPC
###
resource "aws_vpc" "devops-test-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = "true" #gives you an internal domain name
  enable_dns_hostnames = "true" #gives you an internal host name
  enable_classiclink   = "false"
  instance_tenancy     = "default"

  tags = {
    Name = "devops-test-vpc-${var.CandidateName}"
  }
}

###
### Internet Gateway
###
resource "aws_internet_gateway" "devops-test-igw" {
  vpc_id = aws_vpc.devops-test-vpc.id

  tags = {
    Name = "devops-test-igw-${var.CandidateName}"
  }
}

###
### Private Subnets
###
resource "aws_subnet" "devops-test-private-subnet-1a" {
  vpc_id                  = aws_vpc.devops-test-vpc.id
  cidr_block              = var.vpc_cidr_private_subnet_1a
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "devops-test-private-subnet-1a-${var.CandidateName}"
  }
}

resource "aws_subnet" "devops-test-private-subnet-1b" {
  vpc_id                  = aws_vpc.devops-test-vpc.id
  cidr_block              = var.vpc_cidr_private_subnet_1b
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "devops-test-private-subnet-1b-${var.CandidateName}"
  }
}

###
### Public Subnets
###
resource "aws_subnet" "devops-test-public-subnet-1a" {
  vpc_id                  = aws_vpc.devops-test-vpc.id
  cidr_block              = var.vpc_cidr_public_subnet_1a
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "devops-test-public-subnet-1a-${var.CandidateName}"
  }
}

resource "aws_subnet" "devops-test-public-subnet-1b" {
  vpc_id                  = aws_vpc.devops-test-vpc.id
  cidr_block              = var.vpc_cidr_public_subnet_1b
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "devops-test-public-subnet-1b-${var.CandidateName}"
  }
}

###
### NAT Gateways
###
resource "aws_eip" "devops-test-eip-natgw-1a" {
  vpc   = true
  tags = {
    Name = "devops-test-eip-natgw-1a-${var.CandidateName}"
  }
}

resource "aws_eip" "devops-test-eip-natgw-1b" {
  vpc   = true
  tags = {
    Name = "devops-test-eip-natgw-1b-${var.CandidateName}"
  }
}

resource "aws_nat_gateway" "devops-test-natgw-1a" {
  subnet_id = aws_subnet.devops-test-public-subnet-1a.id
  allocation_id = aws_eip.devops-test-eip-natgw-1a.id

  tags = {
    Name = "devops-test-natgw-1a-${var.CandidateName}"
  }

  depends_on = [aws_internet_gateway.devops-test-igw]
}

resource "aws_nat_gateway" "devops-test-natgw-1b" {
  subnet_id = aws_subnet.devops-test-public-subnet-1b.id
  allocation_id = aws_eip.devops-test-eip-natgw-1b.id

  tags = {
    Name = "devops-test-natgw-1b-${var.CandidateName}"
  }

  depends_on = [aws_internet_gateway.devops-test-igw]
}

###
### Route Tables Public
###
resource "aws_route_table" "devops-test-rt-public" {
  vpc_id = aws_vpc.devops-test-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops-test-igw.id
  }

  tags = {
    Name = "devops-test-rt-public-${var.CandidateName}"
  }
}

resource "aws_route_table_association" "devops-test-rt-public-subnet-1a" {
  subnet_id      = aws_subnet.devops-test-public-subnet-1a.id
  route_table_id = aws_route_table.devops-test-rt-public.id
}

resource "aws_route_table_association" "devops-test-rt-public-subnet-1b" {
  subnet_id      = aws_subnet.devops-test-public-subnet-1b.id
  route_table_id = aws_route_table.devops-test-rt-public.id
}

###
### Route Tables Private
###
resource "aws_route_table" "devops-test-rt-private-1a" {
  vpc_id = aws_vpc.devops-test-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.devops-test-natgw-1a.id
  }

  tags = {
    Name = "devops-test-rt-private-1a-${var.CandidateName}"
  }
}

resource "aws_route_table" "devops-test-rt-private-1b" {
  vpc_id = aws_vpc.devops-test-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.devops-test-natgw-1b.id
  }

  tags = {
    Name = "devops-test-rt-private-1b-${var.CandidateName}"
  }
}

resource "aws_route_table_association" "devops-test-rt-private-subnet-1a" {
  subnet_id      = aws_subnet.devops-test-private-subnet-1a.id
  route_table_id = aws_route_table.devops-test-rt-private-1a.id
}

resource "aws_route_table_association" "devops-test-rt-private-subnet-1b" {
  subnet_id      = aws_subnet.devops-test-private-subnet-1b.id
  route_table_id = aws_route_table.devops-test-rt-private-1b.id
}

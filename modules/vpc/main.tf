# vpc creation
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.env-prefix}-vpc"
  }
}

#connection of internet gateway to the vpc
resource "aws_internet_gateway" "inter-gate" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env-prefix}-igw"
  }
}

#data source for availability zone
data "aws_availability_zones" "available_zones" {}


# subnet for az1
resource "aws_subnet" "subnet-az1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.subnet-az1-cidr
  availability_zone = data.aws_availability_zones.available_zones.names[0]

  tags = {
    Name = "${var.env-prefix}-subnet-az1"
  }
}

# subnet for az2
resource "aws_subnet" "subnet-az2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.subnet-az2-cidr
  availability_zone = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env-prefix}-subnet-az2"
  }
}

# route table creation and the public route
resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.inter-gate.id
  }

  tags = {
    Name = "${var.env-prefix}-internet-gateway"
  }
}

# association table1
resource "aws_route_table_association" "rtb-assoc1" {
  subnet_id = aws_subnet.subnet-az1.id
  route_table_id = aws_route_table.rtb.id
}

# association table 2
resource "aws_route_table_association" "rbt-assoc2" {
  subnet_id = aws_subnet.subnet-az2.id
  route_table_id = aws_route_table.rtb.id
}



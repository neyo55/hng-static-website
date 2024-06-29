# network.tf

# create a vpc for the network
resource "aws_vpc" "static_website_vpc" {
  cidr_block = var.vpc_cidr_block


  tags = {
    Name = "${var.project_name}_vpc"
  }
}

# create subnet for the vpc
resource "aws_subnet" "static_website_subnet" {
  vpc_id                  = aws_vpc.static_website_vpc.id
  cidr_block              = var.subnet_cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}_subnet"
  }
}

# create an internet gateway
resource "aws_internet_gateway" "static_website_igw" {
  vpc_id = aws_vpc.static_website_vpc.id

  tags = {
    Name = "${var.project_name}_internet_gateway"
  }
}

# create route table
resource "aws_route_table" "static_website_route_table" {
  vpc_id = aws_vpc.static_website_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.static_website_igw.id
  }

  tags = {
    Name = "${var.project_name}_route_table"
  }
}

# associate the route table with the subnet
resource "aws_route_table_association" "static_website_route_table_association" {
  subnet_id      = aws_subnet.static_website_subnet.id
  route_table_id = aws_route_table.static_website_route_table.id
}


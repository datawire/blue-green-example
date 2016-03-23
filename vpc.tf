// file: vpc.tf

resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr_block_prefix}.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags {
    Name = "${var.vpc_name}"
  }

  lifecycle { create_before_destroy = true }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${aws_vpc.main.id}-igw"
  }
}

resource "aws_route" "internet" {
  route_table_id         = "${aws_vpc.main.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main.id}"
  depends_on             = ["aws_internet_gateway.main"]
}

resource "aws_subnet" "public" {
  availability_zone       = "${concat(var.environment_region, element(split(",", lookup(var.availability_zones, var.environment_region)), count.index))}"
  cidr_block              = "${var.vpc_cidr_block_prefix}.${lookup(var.public_subnet_cidr_suffixes, count.index)}"
  count                   = "${length(split(",", lookup(var.availability_zones, var.environment_region)))}"
  depends_on              = ["aws_internet_gateway.main"]
  map_public_ip_on_launch = true
  vpc_id                  = "${aws_vpc.main.id}"

  tags {
    Name = "${var.vpc_name}-public${count.index}"
  }
}

resource "aws_route_table_association" "public" {
  count          = "${length(split(",", lookup(var.availability_zones, var.environment_region)))}"
  depends_on     = ["aws_vpc.main", "aws_internet_gateway.main"]
  route_table_id = "${aws_vpc.main.main_route_table_id}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
}

resource "aws_security_group" "internal" {
  name_prefix = "internal-"
  description = "allow all traffic between instances in this group"
  vpc_id      = "${aws_vpc.main.id}"

  egress {
    from_port   = 0
    protocol    = -1
    self        = true
    to_port     = 0
  }

  ingress {
    from_port = 0
    protocol  = -1
    self      = true
    to_port   = 0
  }
}

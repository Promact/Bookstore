provider "aws" {
  region = local.region
}

resource "aws_vpc" "this" {
  cidr_block = local.vpc_cidr
  tags = {
    Name = "${local.resource_tag_prefix}-vpc"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${local.resource_tag_prefix}-igw"
  }
}

resource "aws_subnet" "public" {
  count                   = length(local.public_subnet_cidrs)
  cidr_block              = local.public_subnet_cidrs[count.index]
  availability_zone       = local.availability_zones[count.index]
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.resource_tag_prefix}-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count                   = length(local.private_subnet_cidrs)
  cidr_block              = local.private_subnet_cidrs[count.index]
  availability_zone       = local.availability_zones[count.index]
  vpc_id                  = aws_vpc.this.id

  tags = {
    Name = "${local.resource_tag_prefix}-private-subnet-${count.index + 1}"
  }
}

resource "aws_eip" "this" {
  count      = local.elastic_ip_count
  vpc        = true
  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {
  count         = local.nat_gateway_count
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.this.*.id, count.index)
   tags = {
    Name = "${local.resource_tag_prefix}-nat-gateway-${count.index + 1}"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${local.resource_tag_prefix}-public-rt"
  }
}

resource "aws_route_table_association" "public_associations" {
  count = length(aws_subnet.public.*.id)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private" {
  count  = length(aws_nat_gateway.this.*.id)
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[count.index].id
  }

  tags = {
    Name = "${local.resource_tag_prefix}-private-rt-${count.index + 1}"
  }
}

resource "aws_route_table_association" "private_associations" {
  count = length(aws_subnet.private.*.id)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}


resource "aws_security_group" "lb" {
  name   = "${local.resource_tag_prefix}-ecs-ec2-alb-sg"
  vpc_id = aws_vpc.this.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_task" {
  name   = "${local.resource_tag_prefix}-ecs-task-sg"
  vpc_id = aws_vpc.this.id

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.lb.id]
  }

  ingress {
    protocol    = "tcp"
    from_port = 5001
    to_port = 5001
    security_groups = [aws_security_group.lb.id]
  }


  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

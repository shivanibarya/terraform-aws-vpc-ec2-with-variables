resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/21"

  tags = {
    Name  = var.vpc_name
    Env   = var.tags[2]
    Owner = var.tags[1]
  }
}

resource "aws_subnet" "pub_sub" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.0.0/22"
  availability_zone = var.instance_config[0]

  tags = {
    Name  = "${var.tags[0]}-public"
    Env   = var.tags[2]
    Owner = var.tags[1]
  }
}

resource "aws_subnet" "pri_sub" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnet_cidr[0]
  availability_zone = "us-west-1c"

  tags = {
    Name  = "${var.tags[0]}-private"
    Env   = var.tags[2]
    Owner = var.tags[1]
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name  = "${var.tags[0]}-igw"
    Env   = var.tags[2]
    Owner = var.tags[1]
  }
}

resource "aws_route_table" "my_rt" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name  = "${var.tags[0]}-private-rt"
    Env   = var.tags[2]
    Owner = var.tags[1]
  }
}

resource "aws_route_table_association" "my_prta" {
  route_table_id = aws_route_table.my_rt.id
  subnet_id      = aws_subnet.pri_sub.id
}

resource "aws_route_table" "my_pubrt" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name  = "${var.tags[0]}-public-rt"
    Env   = var.tags[2]
    Owner = var.tags[1]
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.my_pubrt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

resource "aws_route_table_association" "my_pubrta" {
  route_table_id = aws_route_table.my_pubrt.id
  subnet_id      = aws_subnet.pub_sub.id
}

resource "aws_security_group" "my_sg" {
  name        = "my_sg_1"
  description = "allow ssh access"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "${var.tags[0]}-sg"
    Env   = var.tags[2]
    Owner = var.tags[1]
  }
}

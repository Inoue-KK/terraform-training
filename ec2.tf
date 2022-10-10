data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "vm-1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.vm1-key-pair.id
  subnet_id     = aws_subnet.vm1-subnet.id
  vpc_security_group_ids = [
    aws_security_group.allow-tls.id
  ]
  depends_on = [
    aws_internet_gateway.gw
  ]
  tags = {
    name = "vm-1"
  }
}

resource "aws_key_pair" "vm1-key-pair" {
  key_name   = "${var.project_unique_id}-vm1-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_subnet" "vm1-subnet" {
  vpc_id     = aws_vpc.vm1-vpc.id
  cidr_block = "10.0.3.0/24"
}

resource "aws_vpc" "vm1-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_security_group" "allow-tls" {
  name   = "${var.project_unique_id}-allow-tls"
  vpc_id = aws_vpc.vm1-vpc.id
}

resource "aws_security_group_rule" "allow-tls-ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = var.allowed_ipaddr_list
  security_group_id = aws_security_group.allow-tls.id
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vm1-vpc.id
}

resource "aws_eip" "vm-1" {
  tags = {
    Name = "vm-1"
  }
}

resource "aws_eip_association" "vm-1-eip" {
  instance_id   = aws_instance.vm-1.id
  allocation_id = aws_eip.vm-1.id
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.vm1-vpc.id
}

resource "aws_route" "r" {
  route_table_id         = aws_route_table.main.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.vm1-subnet.id
  route_table_id = aws_route_table.main.id
}
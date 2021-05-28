provider "aws" {
  region = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
  token = var.token
}

# Create VPC
resource "aws_vpc" "personal_vpc" {
  cidr_block = "172.31.0.0/16"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  enable_classiclink = "true"
  enable_classiclink_dns_support = "true"
  instance_tenancy = "default"
}

# Create Subnet
resource "aws_subnet" "personal_subnet" {
  vpc_id = aws_vpc.personal_vpc.id
  cidr_block = "172.31.64.0/20"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1f"
}

# Create Gateway
resource "aws_internet_gateway" "personal_gateway" {
  vpc_id = aws_vpc.personal_vpc.id
}

# Create Route Table
resource "aws_route_table" "personal_route_table" {
  vpc_id = aws_vpc.personal_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.personal_gateway.id
  }
}

resource "aws_route_table_association" "personal_subnet_route_table" {
  subnet_id = aws_subnet.personal_subnet.id
  route_table_id = aws_route_table.personal_route_table.id
}

# Create Security group
resource "aws_security_group" "all_traffic" {
  vpc_id = aws_vpc.personal_vpc.id
  name = "all_traffic"

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Master node
resource "aws_instance" "master" {
  subnet_id = aws_subnet.personal_subnet.id
  ami = "ami-09e67e426f25ce0d7"
  instance_type = "t2.medium"
  key_name = var.aws_private_key_name
  tags = {
    Name = "master"
  }
  private_ip = var.master_ip
  vpc_security_group_ids = [aws_security_group.all_traffic.id]

  # Copy configuration file
  provisioner "file" {
    source = "install_master.sh"
    destination = "/tmp/install_master.sh"

    connection {
      host = self.public_dns
      type = "ssh"
      user = "ubuntu"
      private_key = file(var.aws_private_key_path)
    }
  }

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -i '${var.aws_private_key_path}' ${var.aws_private_key_path} ubuntu@${self.public_dns}:/home/ubuntu/.ssh"
  }

  # Exec configuration file
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_master.sh",
      "/bin/bash /tmp/install_master.sh ${var.aws_private_key_path} ${var.slaves_count * var.machine_cores}",
    ]

    connection {
      host = self.public_dns
      type = "ssh"
      user = "ubuntu"
      private_key = file(var.aws_private_key_path)
    }
  }
}

# Slave nodes
resource "aws_instance" "slaves" {
  subnet_id = aws_subnet.personal_subnet.id
  ami = "ami-09e67e426f25ce0d7"
  instance_type = "t2.medium"
  key_name = var.aws_private_key_name
  count = var.slaves_count
  tags = {
    Name = lookup(var.slaves_name, count.index)
  }
  private_ip = lookup(var.slaves_ip, count.index)
  vpc_security_group_ids = [aws_security_group.all_traffic.id]

  # Copy configuration file
  provisioner "file" {
    source = "install_slaves.sh"
    destination = "/tmp/install_slaves.sh"

    connection {
      host = self.public_dns
      type = "ssh"
      user = "ubuntu"
      private_key = file(var.aws_private_key_path)
    }
  }

  # Exec configuration file
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_slaves.sh",
      "/bin/bash /tmp/install_slaves.sh ${var.slaves_count * var.machine_cores}",
    ]

    connection {
      host = self.public_dns
      type = "ssh"
      user = "ubuntu"
      private_key = file(var.aws_private_key_path)
    }
  }
}

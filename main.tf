provider "aws" {
  region = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
  token = var.token
}

resource "aws_security_group" "all_traffic" {
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

resource "aws_instance" "master" {
  subnet_id = "subnet-2eea8420"
  ami = "ami-042e8287309f5df03"
  instance_type = "t2.large"
  key_name = var.aws_private_key_name
  tags = {
    Name = "master"
  }
  private_ip = var.master_ip
  #private_dns = var.master_dns
  vpc_security_group_ids = [aws_security_group.all_traffic.id]
  
  provisioner "file" {
    source = var.aws_private_key_path
    destination = "/home/ubuntu/.ssh/key.pem"

    connection {
      host = self.public_dns
      type = "ssh"
      user = "ubuntu"
      private_key = file(var.aws_private_key_path)
    }
  }

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

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_master.sh",
      "/bin/bash /tmp/install_master.sh",
    ]

    connection {
      host = self.public_dns
      type = "ssh"
      user = "ubuntu"
      private_key = file(var.aws_private_key_path)
    }
  }
}

resource "aws_instance" "slaves" {
  subnet_id = "subnet-2eea8420"
  ami = "ami-042e8287309f5df03"
  instance_type = "t2.large"
  key_name = var.aws_private_key_name
  count = var.slaves_count
  tags = {
    Name = lookup(var.slaves_name, count.index)
  }
  private_ip = lookup(var.slaves_ip, count.index)
  vpc_security_group_ids = [aws_security_group.all_traffic.id]

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

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_slaves.sh",
      "/bin/bash /tmp/install_slaves.sh",
    ]

    connection {
      host = self.public_dns
      type = "ssh"
      user = "ubuntu"
      private_key = file(var.aws_private_key_path)
    }
  }
}

variable "access_key" {
  type = string
  default = ""
}

variable "secret_key" {
  type = string
  default = ""
}

variable "token" {
  type = string
  default = ""
}

variable "aws_private_key_name" {
  type = string
  default = "Key_01"
}

variable "aws_private_key_path" {
  type = string
  default = "Key_01.pem"
}

variable "master_ip" {
  type = string
  default = "172.31.67.1"
}

variable "master_dns" {
  type = string
  default = "ip-172-31-67-1.ec2.internal"
}

variable "slaves_count" {
  type = number
  default = 1
}

variable "slaves_name" {
  default = {
    "0" = "slave_0"
  }
}

variable "slaves_ip" {
  default = {
    "0" = "172.31.67.2"
  }
}

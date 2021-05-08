variable "access_key" {
  type = string
  default = ""  # Insert your access key
}

variable "secret_key" {
  type = string
  default = ""  # Insert your secret key
}

variable "token" {
  type = string
  default = ""  # Insert your token
}

variable "slaves_count" {
  type = number
  default = 1   # Set the number of slaves of the cluster
}

variable "aws_private_key_name" {
  type = string
  default = ""  # Insert name of your private key
}

variable "aws_private_key_path" {
  type = string
  default = ""  # Insert name and file extension of your private key
}

variable "master_ip" {
  type = string
  default = "172.31.67.1"
}

variable "master_dns" {
  type = string
  default = "ip-172-31-67-1.ec2.internal"
}

variable "slaves_name" {
  default = {
    "0" = "slave_0"
    "1" = "slave_1"
    "2" = "slave_2"
    "3" = "slave_3"
    "4" = "slave_4"
    "5" = "slave_5"
    "6" = "slave_6"
    "7" = "slave_7"
  }
}

variable "slaves_ip" {
  default = {
    "0" = "172.31.67.2"
    "1" = "172.31.67.3"
    "2" = "172.31.67.4"
    "3" = "172.31.67.5"
    "4" = "172.31.67.6"
    "5" = "172.31.67.7"
    "6" = "172.31.67.8"
    "7" = "172.31.67.9"
  }
}

variable "machine_cores" {
  type = number
  default = 2
}

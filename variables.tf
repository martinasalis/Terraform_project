variable "access_key" {
  type = string
  default = "<your_access_key>"
}

variable "secret_key" {
  type = string
  default = "<your_secret_key>"
}

variable "token" {
  type = string
  default = "<your_token>"
}

variable "aws_private_key_name" {
  type = string
  default = "<your_aws_private_key_name>"
}

variable "aws_private_key_path" {
  type = string
  default = "<your_aws_private_key_path>"
}

variable "slaves_count" {
  type = number
  default = 2
}

variable "slaves_name" {
  default = {
    "0" = "slave_0"
    "1" = "slave_1"
  }
}

variable "slaves_ip" {
  default = {
    "0" = "172.31.67.2"
    "1" = "172.31.67.3"
  }
}

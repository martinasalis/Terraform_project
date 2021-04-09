variable "access_key" {
  type = string
  default = "ASIAWB5K476L6SLEW3NH"
}

variable "secret_key" {
  type = string
  default = "pQGnnnETlgLFSBniFImvIn4CaTM0lkDUJtmX4Qkw"
}

variable "token" {
  type = string
  default = "IQoJb3JpZ2luX2VjEBkaCXVzLXdlc3QtMiJIMEYCIQDC4tQqlNotPx+IN6LUWAxiOt5gWZmhJOjCSabCXFeNdAIhAMkSNI3KBr3VaoNgWP42EOCs+w/5iIgh35b8/wOfcyZjKrQCCHIQABoMNDE2NDMzMzczMDc5IgzdL2XczaARGtquzLgqkQKfOT/RG4fmrC+GqHr2E1QhZCFOoeXU/rp+UinB+CJxlxYcpWwMLJ00VTxlgqCf3jBN6HZ/EVNaTDKfRCAgOdXYA2jNQ6GI0XeDM0lBSlR2GCXsBKIY6vLlhgFMawzQnHKrLOMgulGPuU9CK6U13BuvUvH/GUDbHcK8rSAU6Al1v+EdlEmXkeoCMe4kVGqAZY4t2N3rTLKn2xVdn72FPabebfVTvdt0ruMtbJUldJg7cm/yBRgEw+i8NqQ5ZWmq87i+9gdGZQle7ctuf9wGN1zgwHM5XS0HSadVkcwMUx+8jTzNss1b4jqsO9rlzqRsmUPVjpB4kYW9f1Jzoi+Fr/oYijiog7MCl0AdBstncaAxnA4woKvAgwY6nAH3B0rFQjTi15Ilj9s9cLRacU/ty6wqNpnGCrdkzNthArFVJdIkGI/fPqfnySPl5JW/TUcyhXlQcbhv9B0iAnRjTouGjhseqV4UGM5dp7tKAf390A33/nDU/MnF3qhP7pyE8UQuFiJWrUnVaQGkSNI8QJ27ZtMUgXaXG47amz8fQES9pIo+DlgIN8lDzzbxwoaJWSme8Tdrl9IUOgM="
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

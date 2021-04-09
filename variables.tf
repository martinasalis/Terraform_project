variable "access_key" {
  type = string
  default = "ASIAWB5K476L7QJAWAWZ"
}

variable "secret_key" {
  type = string
  default = "lT79aso9HD1IVlEaOmrErIGhNeblf/qMGvGD0WMa"
}

variable "token" {
  type = string
  default = "IQoJb3JpZ2luX2VjECEaCXVzLXdlc3QtMiJGMEQCID6WVEGsDvW6dtz2x50x220WBSXVVIllHylfNGkkDtvBAiBfYBpkKNDQzhdgUBhSVHBAHB2tc0o/jPZ/cwILQ1ObeSq0Agh6EAAaDDQxNjQzMzM3MzA3OSIMgnpyVZBjz4J/jgpYKpECMpEVJGQU1A+dtSpJ+ZBIqpw43HvWFnMbESqwlTXe81cODA7ue3aZDqXqNg1I+wi6NrkKtK+uliv3r3r0lCE/jGD/KnkHB8hFrW8bT+ObzZSJboq7Q9YQirloHq5wYsq/loF5IQzUlLNZrencMJ567vI2IUKNajdnXzd3Wd6P7dd7DwrMg/PwEFHoyk6bCNhHNWk2U5M0oOpExTnPVrazMb+9CxqZYv67l6I5N9LFny8QEs54FwC2FH3mxQvSXEppbiDdo1H45IjU5RSiLy2PKebnjQnBPnQUmPEmCsY2jfbijwD/RhEm2wUxrE8S03Sjk9UaDppfOUz0fnncvjymXZELxEo4tmQ5/d3Fv7397JHUMPGOwoMGOp4B+0ipxEbYzv+7ISCkjQ8rj+BUOF4GW4u6l3ogUTyY6zbAwPeTLwKuA3yhpTU0xCJ6NEDL3LBndTYlsshShy/HK3ipDc9PwLFiuX5YNt/t1//IpUHrx27NvwCeOkzW1WFx//nSn83Zoehh+N5Juo04+hCnJtHgmT5u/prjHG9GN2GRuOltlIkBjPu/4uhg1VYHCHNw9mJjN3q1ehubctA="
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

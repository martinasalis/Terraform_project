variable "access_key" {
  type = string
  default = "ASIAWB5K476LVOEVYXPD"
}

variable "secret_key" {
  type = string
  default = "aUrc+AdPnVB1MoAx4Y+6R84VrrjOBCStFQSd8bpd"
}

variable "token" {
  type = string
  default = "IQoJb3JpZ2luX2VjEGUaCXVzLXdlc3QtMiJGMEQCIB7n/z83JcuOjTEdvekpeBYujyGYnFAHkeZQXU1ntw8PAiAj+Jh0rjw2xMN02X1rbhHpIp/sJnqcaxBWVzdBS5veBiq9Agi+//////////8BEAAaDDQxNjQzMzM3MzA3OSIMicDdnoQ5VNw6EmWfKpECIBrOEFdFzEEuacS92fB9VDjGyvK4RfGxNVp7rzntInR9Ry81FPmZudpGoC/X6RP2abIpbjHP7kB+MVOAemD4WyFuQxirctbp1FZ9clj0I/MEFfyJRRuAcDZCVQPnfrKRG3ND7jOgXkig3+vf5XYwoDuoeU+xhoTrnobH5bDCkzgc9fAk2DhdxpTk+CIdihup3A72jkkfswhmblRTdD7KHPd3CVRbqkpqnFvZARooWjSuZK415+FnWxwrCed7vP8yNz5TArO5brgZLNmYZPZ74U2MYDsMW24WEJfBz7WS3K9D8yXM/m8K2PXm9W8A/3iC7mv97dCCgpQC/CjIZGlJgyB35rdGq/C8ma2bcHKHFP9xMPKF0YMGOp4B1l4bUjjAZyM/XAP6fynqcjSILB5ZnO5EeJOJoaw4Uh8QKiECiR/YE3CwNW4dbEc+4T2F7alfO8l9EHo3Q4oCerAPjKkVcc64xAZBDbnAfF7qnSJxAyrNW5IlItK/baHNxkTcmHxzm4TWL7tjkxogovCKCNVYMdjS3WCuB6J4+yF1SA/Lh9xMMPb+k/M+WIiL9h2X9o7eiLerYP5qkzA="
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

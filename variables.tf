variable "access_key" {
  type = string
  default = "ASIAWB5K476L2HRIO2UY"
}

variable "secret_key" {
  type = string
  default = "dMaslWe/ucam23NX/7LwRNSKlyJIosC7ZkarnjVM"
}

variable "token" {
  type = string
  default = "IQoJb3JpZ2luX2VjEAIaCXVzLXdlc3QtMiJIMEYCIQD0YEl/xOG/JFz2LM51hPa3+x/Kpn30AEZWfgNnEwLE/gIhANIikp26A/GRKqKSfhAtDFeZcrE7SLfAtVshwZ5I6q4cKrQCCFsQABoMNDE2NDMzMzczMDc5IgwNVgyCvDYAWkdri1sqkQKwPcATTJVHc3rCwwc6LpmokpDIbD5yv9pEJ0FlZdTzfjkAWLobRtBujSxA3gEp0gkEPiVCwq96Vzad/fg+ZgRMwm6QPBS55VUfW0Y0pmfd0BFmcLMBNVqsO4FBKI+aFJh4scS0MzHukXcy9YDnGHpkeWJScbV5B1bq4qgMg7Ms1EX28W32BRGVzZFT1pDzkLG5pRXWppSlFBctBmci+YKAQc4QSU2GuRrphKdgMgOGSDxpAp4Xzv8XEOFSktigLWJfQoKqLcrI5TZ1PL7g0EGH87sz/IpJMSmJFxD6p/JMrmA+lPSWVm09tIMQPBfyhi2lcRL/+U8AxKhYIbhfClM5AWAOIsy+B0aqX7XQaGnLQdkwmae7gwY6nAEhmwkseKBhaGW1Lu3QDHusNN+T0ieF1eF0okqPCmXgnYyyYf8yQfK3+yX3rL+v9VWZY6yMYcikOn0kBepyeg9cMjTf95gdf9QuPN4Ag/gmZy9aZhwh3y/RZ6wDWR7F/iOKh9FQVPhLLMEyufwwGcf2jysIv6T0vDFxPijFMVTRSOhp+Ph59lH7ViCQH53R8F988m11r17WAp2v6Hk="
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

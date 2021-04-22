output "Public_IP_Master" {
    value = aws_instance.master.public_ip
}

output "Public_DNS_Master" {
    value = aws_instance.master.public_dns
}

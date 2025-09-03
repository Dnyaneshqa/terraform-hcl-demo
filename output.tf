output "subnet_ids" {
    value = aws_subnet.demo_subnet[*].id
}

output "instance_ips" {
    value = {for k, v in aws_instance.servers : k => v.public_ip}
}
provider "aws" {
    region = "us-east-1"
}

#vpc
resource "aws_vpc" "demo_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = merge(local.tags, {Name = "${local.project}-vpc"})
}

#Subnet using count
resource "aws_subnet" "demo_subnet" {
    count = 2
    vpc_id = aws_vpc.demo_vpc.id
    cidr_block = "10.0.${count.index}.0/24"
    availability_zone = element(["us-east-1a", "us-east-1b"],count.index)
    map_public_ip_on_launch = true

    tags = merge(local.tags, {Name = "${local.project}-subnet-${count.index}"})
}

#Security Group (conditional create)
resource "aws_security_group" "demo_sg" {
    count = var.create_sg ? 1 : 0
    name  = "${local.project}-sg"
    vpc_id = aws_vpc.demo_vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress{
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = merge(local.tags, {Name = "${local.project}-sg"})
}

#Get latest Amazon Linux 2 AMI
data "aws_ami" "latest_amazon_linux" {
    most_recent = true
    owners = ["amazon"]

    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

#EC2 Instances using for each
resource "aws_instance" "web" {
    for_each = var.instance_type
    ami           = var.ami_id != "" ? var.ami_id : data.aws_ami.latest_amazon_linux.id
    instance_type = each.value
    subnet_id     = element(aws_subnet.demo_subnet[*].id, each.key == "web1" ? 0 : 1)
    vpc_security_group_ids = var.create_sg ? [aws_security_group.demo_sg[0].id] : []

    user_data = <<-EOF
                #!/bin/bash
                yup update -y
                amazon-linux-extras install -y nginx1
                systemctl start nginx
                systemctl enable nginx
                EOF

                
    tags = merge(local.tags, {Name = "${local.project}-${each.key}"})
}
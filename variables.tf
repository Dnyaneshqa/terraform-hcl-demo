variable "aws_region" {
  default = "us-east-1"
}

variable "project_name" {
  default = "terraform-demo"  
}

variable "ami_id" {
    description = "Amazon Linux 2 AMI ID for us-east-1"
  
}

variable "instance_type" {
    type = map(string)
    default = {
        web1 = "t2.micro"
        web2 = "t2.micro"
    }
}

variable "create_sg" {
    type = bool
    default = true
  
}
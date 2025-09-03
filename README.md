# terraform-hcl-demo

📘 README.md – Terraform HCL AWS Mini Project

🚀 Project Overview
This project demonstrates the core Terraform language (HCL) concepts by building a small AWS infrastructure.
It covers variables, outputs, locals, data sources, dependencies, conditionals, loops (count, for_each) all in a single project.

The project provisions:

VPC (10.0.0.0/16)

2 Public Subnets (using count)

Security Group (conditional creation)

EC2 Instances (using for_each) with Nginx installed

Outputs: Subnet IDs and EC2 Public IPs

This is a learning-friendly project and a starting point for modular/production setups.

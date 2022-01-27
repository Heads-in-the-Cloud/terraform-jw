terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # version -- is optional (need to check what this is)
    }
  }
}
provider "aws" {
  profile = "default"
  region  = "us-east-2" 
}   
resource "aws_instance" "terraform_ec2_instance" {

  ami = "ami-002068ed284fb165b"
  instance_type = "t2.micro"
      tags = {
        Name = "terraform_ec2_instance"
    }
}
resource "aws_security_group" "terraform_security_group"{
    description= "allow all traffic"
    ingress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
}
resource "aws_iam_role_policy" "terraform_iam_policy"{
    name = "terraform_iam_policy"
    
    role = aws_iam_role.terraform_iam_role.id

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Action = [
            "ec2:Describe*",
            ]
            Effect   = "Allow"
            Resource = "*"
        },
        ]
    })
}
resource "aws_iam_role" "terraform_iam_role"{
    name = "terraform_iam_role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Sid = ""
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            },
        ]
    })
}
resource "aws_vpc" "terraform_vpc"{
    cidr_block = "172.31.32.0/20"
    instance_tenancy = "default"
    tags = {
        Name = "terraform_vpc"
    }
}
resource "aws_lb" "terraform_alb"{
    name = "terraform-alb"
    load_balancer_type = "application"
    security_groups = ["${aws_security_group.terraform_security_group.id}"]
    subnets = ["subnet-0b7971050291b03ef", "subnet-0f1e33515d814b669"]
}
resource "aws_route_table" "terraform_route_table" {
    vpc_id = "${aws_vpc.terraform_vpc.id}"
}
resource "aws_internet_gateway" "terraform_igw" {
    vpc_id = "${aws_vpc.terraform_vpc.id}"
}
resource "aws_nat_gateway" "terraform_ngw" {
    subnet_id = "subnet-0b7971050291b03ef"
    connectivity_type = "private"
}
resource "aws_kms_key" "tf_key" {
  description = "Jon key 1"
  deletion_window_in_days = 10
}
# resource "aws_s3_bucket" "terraform_jon_ss_jesus_christ_bucket" {
#   bucket = "my-tf-test-bucket"
#   tags = {
#     Name        = "terraform_jon_ss_bucket"
#   }
# }
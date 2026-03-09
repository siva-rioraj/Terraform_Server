#step1 : Configure the provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
# Configure the AWS Provider
provider "aws" {
  region = "eu-north-1"
}
#step2 : Create a VPC
resource "aws_vpc" "VPCBC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "VPCBootcamp"
  }
}

#step3 : create the public subnet
resource "aws_subnet" "subnetBC" {
  vpc_id     = aws_vpc.VPCBC.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "publicsub_Bootcamp"
  }
}

#step4 : ineternet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.VPCBC.id

  tags = {
    Name = "IGM_Bootcamp"
  }
}

#Step5 : route table 
resource "aws_route_table" "routeBC" {
  vpc_id = aws_vpc.VPCBC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Route_BC"
  }
}
#Step6 : Subnet Association
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnetBC.id
  route_table_id = aws_route_table.routeBC.id
}
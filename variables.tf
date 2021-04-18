variable "VPC_CIDR" {
  type    = string
  default = ""
}

variable "VPC_Name" {
  type    = string
  default = ""
}

variable "Subnet_Name" {
  type    = string
  default = ""
}

variable "Subnet_CIDR" {
  type    = string
  default = ""
}

variable "IGW_Name" {
  type    = string
  default = ""
}

variable "SecurityGroup_Name" {
  type    = string
  default = ""
}

variable "EC2_Name" {
  type    = string
  default = ""
}

variable "EC2_Size" {
  type    = string
  default = ""
}

variable "AMI_ID" {
  type    = string
  default = ""
}

variable "RouteTable_PublicName" {
  type    = string
  default = ""
}

#BootStrap Script
locals {
  html_install = <<EOF
    #!/bin/bash

    sudo yum update
    sudo yum install httpd -y
    sudo systemctl start httpd
    sudo systemctl enable httpd

    sudo yum install ruby -y
    sudo yum install wget -y

    cd /home/ec2-user
    wget https://aws-codedeploy-ap-southeast-1.s3.ap-southeast-1.amazonaws.com/latest/install
    chmod +x ./install
    sudo ./install auto
    sudo service codedeploy-agent start
    
    EOF
}

variable "Github_token" {
  type    = string
  default = ""
}

variable "Github_owner" {
  type    = string
  default = ""
}

variable "Github_repo" {
  type    = string
  default = ""
}

variable "Github_branch" {
  type    = string
  default = ""
}

variable "Pipeline_name" {
  type    = string
  default = ""
}
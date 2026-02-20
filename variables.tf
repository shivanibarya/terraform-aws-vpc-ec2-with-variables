variable "aws_region" {
  type    = string
  default = "us-west-1"
}

variable "vpc_name" {
  type    = string
  default = "vpc-1"
}

variable "ssh_port" {
  type    = number
  default = 22
}

variable "associate_public_ip" {
  type    = bool
  default = true
}

variable "private_subnet_cidr" {
  type    = list(string)
  default = ["10.0.4.0/23"]
}

variable "instance_config" {
  type    = tuple([string, string])
  default = ["us-west-1a", "t3.micro"]
}

variable "common_tags" {
  type = map(string)
  default = {
    Owner   = "Shivani"
    Project = "Terraform-VPC-EC2"
    Env     = "Dev"
  }
}

variable "ec2_config" {
  type = object({
    ami           = string
    instance_type = string
    name          = string
  })

  default = {
    ami           = "ami-0d53d72369335a9d6"
    instance_type = "t3.micro"
    name          = "shivani-inst"
  }
}

variable "tags" {
  description = "Custom tag list"
  type        = any
  default     = ["shivani-resource", "Shivani", "Dev"]
}

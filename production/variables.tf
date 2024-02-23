#variable "aws_key_path" {}
#variable "aws_key_name" {}

variable "project-domain" {
  description = "Identifies the project domain"
  default     = "ochoajenkins.com"
}

variable "environment" {
  description = "Identifies the deployment location: blue or green"
  default     = "BLUE"
}

variable "Created_By" {
  description = "Identifies the team or person that created the infrastructure"
  default     = ""
}

variable "Tool" {
  description = "Identifies the tool use to create the infrastructure"
  default     = "Terraform"
}

variable "aws_region" {
  description = "Identifies AWS region to use"
  default     = "us-west-1"
}

variable "region" {
  description = "Identifies AWS region to use"
  default     = "us-west-1"
}

variable "availability_zones" {
  description = "availability zones to use"
}

variable "cidr_block" {
  description = "CIDR Block"
}


#variable "aws_key_path" {}
#variable "aws_key_name" {}

variable "project_domain" {
  description = "Identifies the project domain"
  default     = ""
}

variable "environment" {
  description = "Identifies the deployment location: blue or green"
  default     = ""
}

variable "dns_record_identifier" {
  description = "Identifies the dns record for the production dns zone"
  default     = ""
}

variable "environment_weight" {
  description = "Identifies the deployment location: blue or green"
  default     = ""
}

variable "Created_By" {
  description = "Identifies the team or person that created the infrastructure"
  default     = ""
}

variable "Tool" {
  description = "Identifies the tool use to create the infrastructure"
  default     = "Terraform"
}

variable "prod_environment" {
  description = "Identifies the deployment location: blue or green"
  default     = "PRODUCTION"
}

variable "availability_zones" {
  description = "Identifies AWS availability zones to use"
  type        = list(string)
}

variable "aws_region" {
  description = "Identifies AWS region to use"
  default     = "us-west-1"
}

variable "region" {
  description = "Identifies AWS region to use"
  default     = "us-west-1"
}

variable "build_id" {
  description = "Build ID to use to identify AMI to use for testing"
  default     = ""
}

variable "test-name" {
  description = "test name"
  default     = "exploratory-testing"
}

variable "amis" {
  description = "AMIs by region"
  default = {
    us-west-1 = "" # ubuntu 
  }
}

variable "cidr_block" {
  description = "CIDR for the whole VPC. Includes both Green and Blue Deployments"
  default     = "10.0.0.0/16"
}


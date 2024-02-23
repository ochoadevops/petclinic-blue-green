variable "infrastructure_version" {
  default = "1"
}

terraform {
  backend "s3" {
    bucket = "01-prod-green"
    region = "us-west-1"
    key    = "terraform.tfstate"
  }
}


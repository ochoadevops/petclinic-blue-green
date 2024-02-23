resource "aws_vpc" "production" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Environment = "PRODUCTION"
    Name        = "VPC-PRODUCTION"
    Created_by  = var.Created_By
    Tool        = var.Tool
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "green_cidr" {
  vpc_id     = aws_vpc.production.id
  cidr_block = "10.1.0.0/16"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.production.id

  tags = {
    Environment = "PRODUCTION"
    Created_by  = var.Created_By
    Tool        = var.Tool
  }
}


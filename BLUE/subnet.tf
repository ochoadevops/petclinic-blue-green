resource "aws_subnet" "terraform-blue-green" {
  count                   = length(var.availability_zones)
  vpc_id                  = data.aws_vpc.production.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "Public-${var.environment}-${element(var.availability_zones, count.index)}-infra-${var.infrastructure_version}"
    build_id    = var.build_id
    Environment = "${var.prod_environment}-${var.environment}"
    Crated_by   = var.Created_By
    Tool        = var.Tool
  }
}

resource "aws_route_table" "rtb_public" {
  vpc_id = data.aws_vpc.production.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.gw.id
  }

  tags = {
    build_id    = var.build_id
    Environment = "${var.prod_environment}-${var.environment}"
  }
}

resource "aws_route_table_association" "rta_subnet_public" {
  count          = length(var.availability_zones)
  subnet_id      = element(aws_subnet.terraform-blue-green.*.id, count.index)
  route_table_id = aws_route_table.rtb_public.id
}


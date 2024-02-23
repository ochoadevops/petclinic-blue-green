locals {
  subnets = [aws_subnet.terraform-blue-green.*.id]
}

resource "aws_security_group" "web_security_group" {
  vpc_id = data.aws_vpc.production.id
  name   = "access-https-${var.environment}-${var.build_id}"
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    build_id    = var.build_id
    Environment = "${var.prod_environment}-${var.environment}"
  }
}

resource "aws_instance" "test-instance" {
  # Since ASG will launch configuration automatically, no longer need to create them here
  #count                  = "${length(var.availability_zones)}"
  count                  = 0
  ami                    = data.aws_ami.instance_ami.id
  instance_type          = "t2.micro"
  key_name               = "DevOps"
  vpc_security_group_ids = [aws_security_group.web_security_group.id]
  subnet_id              = element(local.subnets, count.index)
  tags = {
    build_id    = var.build_id
    Environment = "${var.prod_environment}-${var.environment}"
  }
}


output "instance_public_ips" {
  value = aws_instance.test-instance.*.public_ip
}


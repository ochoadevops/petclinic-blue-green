resource "aws_lb" "terraform-blue-green" {
  name               = "elb-${var.environment}"
  subnets            = aws_subnet.terraform-blue-green.*.id
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.terraform-blue-green.id]

  #Instances will be added by ASG automatically
  #instances = ["${aws_instance.test-instance.*.id}"]

  tags = {
    Name        = "terraform-blue-green-v${var.infrastructure_version}"
    Environment = "${var.prod_environment}-${var.environment}"
    Created_by  = var.Created_By
    Tool        = var.Tool
  }
}

resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.terraform-blue-green.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

output "load_balancer_dns" {
  value = aws_lb.terraform-blue-green.dns_name
}


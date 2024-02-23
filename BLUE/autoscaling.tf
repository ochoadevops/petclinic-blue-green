resource "aws_launch_configuration" "lc_web" {
  image_id        = data.aws_ami.instance_ami.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.terraform-blue-green.id]

  #security_groups = ["${aws_security_group.web_security_group.id}"]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "web" {
  name = "${var.environment}-web-group-1"

  #depends_on  = ["${data.aws_vpc.production.id}"]
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.production.id
  target_type = "instance"

  health_check {
    interval            = 30
    path                = "/index.html"
    port                = 8080
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    protocol            = "HTTP"
    matcher             = "200,202"
  }
}

resource "aws_autoscaling_group" "instance_ami" {
  name                      = "asg-node-app-${aws_launch_configuration.lc_web.name}"
  launch_configuration      = aws_launch_configuration.lc_web.name
  #availability_zones        = var.availability_zones
  min_size                  = 1
  max_size                  = 4
  desired_capacity          = 2
  health_check_grace_period = 60
  termination_policies      = ["OldestLaunchConfiguration"]
  health_check_type         = "ELB"

  vpc_zone_identifier = aws_subnet.terraform-blue-green.*.id
  target_group_arns   = [aws_lb_target_group.web.arn]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Environment"
    value               = "${var.prod_environment}-${var.environment}"
    propagate_at_launch = true
  }
  tag {
    key                 = "Created_By"
    value               = var.Created_By
    propagate_at_launch = true
  }
  tag {
    key                 = "Tool"
    value               = var.Tool
    propagate_at_launch = true
  }
  tag {
    key                 = "build_id"
    value               = var.build_id
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "web_target_tracking_policy" {
  name                      = "web-target-tracking-policy"
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = aws_autoscaling_group.instance_ami.name
  estimated_instance_warmup = 200

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = "60"
  }
}

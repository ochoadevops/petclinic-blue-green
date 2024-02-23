resource "aws_route53_record" "terraform-blue-green" {
  zone_id         = data.aws_route53_zone.terraform-blue-green.zone_id
  name            = "www.${var.project_domain}"
  type            = "A"
  allow_overwrite = true

  weighted_routing_policy {
    weight = var.environment_weight
  }

  set_identifier = var.dns_record_identifier

  alias {
    name                   = "dualstack.${aws_lb.terraform-blue-green.dns_name}"
    zone_id                = aws_lb.terraform-blue-green.zone_id
    evaluate_target_health = false
  }
}


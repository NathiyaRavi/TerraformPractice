
resource "aws_route53_zone" "route-53-zone" {
  
 name = "snvs.live"
 force_destroy = false
}
resource "aws_route53_record" "frontend_record" {
  zone_id = aws_route53_zone.route-53-zone.zone_id # your hosted zone
  name    = "book"                              # book.snvs.live
  type    = "A"

  alias {
    name                   = aws_lb.frontend_alb.dns_name
    zone_id                = aws_lb.frontend_alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "backend-record" {
  zone_id = aws_route53_zone.route-53-zone.zone_id # your hosted zone
  name    = "api"                              # api.snvs.live
  type    = "A"

  alias {
    name                   = aws_lb.backend_alb.dns_name
    zone_id                = aws_lb.backend_alb.zone_id
    evaluate_target_health = true
  }
}



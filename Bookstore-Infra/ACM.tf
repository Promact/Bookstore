    # # Variables
    # variable "domain_name" {
    #   description = "bookstore-Public-ALB-2112943775.us-east-1.elb.amazonaws.com"
    # }

    # # ACM Certificate
    # resource "aws_acm_certificate" "ssl_certificate" {
    #   domain_name       = var.domain_name
    #   validation_method = "DNS"

    #   lifecycle {
    #     create_before_destroy = true
    #   }
    # }

    # # Route 53 Hosted Zone
    # resource "aws_route53_zone" "my_zone" {
    #   name = var.domain_name
    # }

    # # ACM Certificate DNS Validation Record
    # resource "aws_route53_record" "acm_validation" {
    #   for_each = aws_acm_certificate.ssl_certificate.domain_validation_options

    #   name    = each.value.resource_record_name
    #   type    = each.value.resource_record_type
    #   records = [each.value.resource_record_value]
    #   zone_id = aws_route53_zone.my_zone.zone_id
    #   ttl     = 60
    # }



# ############################   Validation using EMAIL   #############################################################################################################



# # ACM Certificate
# resource "aws_acm_certificate" "ssl_certificate" {
#   domain_name       = "bookstore-Public-ALB-2112943775.us-east-1.elb.amazonaws.com"
#   validation_method = "EMAIL"

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# # Wait for ACM Certificate Validation (Email)
# resource "aws_acm_certificate_validation" "ssl_certificate_validation" {
#   certificate_arn = aws_acm_certificate.ssl_certificate.arn
# }

# # ALB Listener Rule for HTTPS
# resource "aws_lb_listener" "alb_listener_https" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = aws_acm_certificate_validation.ssl_certificate_validation.certificate_arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.lb_target_group.arn
#   }
# }


# resource "aws_acm_certificate" "ssl_certificate" {
#   domain_name       = "bookstore-Public-ALB-2112943775.us-east-1.elb.amazonaws.com"
#   validation_method = "DNS"
# }

# resource "aws_acm_certificate_validation" "ssl_certificate_validation" {
#   certificate_arn         = aws_acm_certificate.ssl_certificate.arn
#   validation_record_fqdns = aws_acm_certificate.ssl_certificate.domain_validation_options.*.resource_record_name
# }

# # Ensure ACM certificate validation completes before creating other resources
# resource "null_resource" "wait_for_acm_validation" {
#   depends_on = [aws_acm_certificate_validation.ssl_certificate_validation]

#   provisioner "local-exec" {
#     command = "echo ACM certificate has been successfully validated!"
#   }
# }

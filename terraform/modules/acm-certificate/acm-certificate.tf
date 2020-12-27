variable "domain_name" {
}

variable "subject_alternative_names" {
  type    = list(string)
  default = []
}

variable "validation_method" {
  default = "DNS"
}

variable "zone_id" {
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}

resource "aws_acm_certificate" "certificate" {
  domain_name               = var.domain_name
  validation_method         = var.validation_method
  subject_alternative_names = var.subject_alternative_names
  tags = merge(
    {
      "Name" = replace(var.domain_name, "*", "wildcard")
    },
    var.tags,
  )
}

resource "aws_route53_record" "validation" {
  count   = var.zone_id != "" ? length(var.subject_alternative_names) + 1 : 0
  name    = aws_acm_certificate.certificate.domain_validation_options[count.index]["resource_record_name"]
  type    = aws_acm_certificate.certificate.domain_validation_options[count.index]["resource_record_type"]
  zone_id = var.zone_id
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  records = [aws_acm_certificate.certificate.domain_validation_options[count.index]["resource_record_value"]]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "certificate" {
  count                   = var.zone_id != "" ? length(var.subject_alternative_names) + 1 : 0
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = aws_route53_record.validation.*.fqdn
}

output "arn" {
  value = aws_acm_certificate.certificate.arn
}

output "domain_validation_options" {
  value = aws_acm_certificate.certificate.domain_validation_options
}

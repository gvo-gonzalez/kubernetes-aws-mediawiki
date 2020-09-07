# Get zones available to run our kubernetes cluster
data "aws_availability_zones" "available" {
    state = "available"
}

resource "null_resource" "primary-avz" {
    provisioner "local-exec" {
        command = "echo ${data.aws_availability_zones.available.names[0]} > /tmp/avz1"
    }
}

resource "null_resource" "secondary-avz" {
    provisioner "local-exec" {
        command = "echo ${data.aws_availability_zones.available.names[1]} > /tmp/avz2"
    }
}

resource "null_resource" "third-avz" {
    provisioner "local-exec" {
        command = "echo ${data.aws_availability_zones.available.names[2]} > /tmp/avz3"
    }
}

# Load Balancer Requires a domain name and a certificate issued by AMAZON
data "aws_acm_certificate" "ssl-acm-config" {
    provider    = aws.region_alias
    domain      = var.domain_name
    types       = [var.certificate_issued_by]
    most_recent = true
}

resource "null_resource" "acm-data-resource" {
    provisioner "local-exec" {
        command = "echo ${data.aws_acm_certificate.ssl-acm-config.arn} > /tmp/acm_arn"
    }
}

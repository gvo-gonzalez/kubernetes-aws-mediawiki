provider "aws" {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    region  = var.aws_region
}
provider "aws" {
    alias   = "region_alias"
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    region  = var.aws_region
}
#provider "local-exec" {}
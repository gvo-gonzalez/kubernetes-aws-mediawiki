variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {}
variable "iam_kops_user" {}
variable "iam_kops_group" {}
variable "iam_kops_policy" {
    description = "group policies"
    type    = list
}
#variable "s3Bucket_state" {}
variable "dest_access_key" {}
variable "dest_secret_key" {}
variable "domain_name" {}
variable "certificate_issued_by" {}
variable "kubernetes_states_bucket" {}


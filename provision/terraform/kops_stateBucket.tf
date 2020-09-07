resource "aws_s3_bucket" "k8-states-bucket" {
  bucket = var.kubernetes_states_bucket
  acl = "private"
  force_destroy = true
  
  versioning {
      enabled = true
  }
  
  lifecycle {
    create_before_destroy = true
  }

  tags = {
      Name = "kubecluster-state-store"
  }
}

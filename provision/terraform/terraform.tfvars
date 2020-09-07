aws_access_key = "your_access_key_id"
aws_secret_key = "your_secret_key"
aws_region = "your-region"
iam_kops_user = "kops"
iam_kops_group = "kops"
iam_kops_policy = [
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/AmazonVPCFullAccess"]
kubernetes_states_bucket = "kubecluster-state-store.domain.com"
dest_access_key = "/boxdata/terraform/kops_accesskey"
dest_secret_key = "/boxdata/terraform/kops_secretkey"
domain_name = "domain.com" # Without prefix
certificate_issued_by   = "AMAZON_ISSUED" # Required to configure HTTPS LB listener 
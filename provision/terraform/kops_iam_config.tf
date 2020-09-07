resource "aws_iam_group" "kops-iamgroup" {
    name    = "kops"
}

resource "aws_iam_policy_attachment" "kopsgroup-policy-attach" {
    name    = "kopsgroup-policy-attach"
    groups  = [aws_iam_group.kops-iamgroup.name]
    count   = length(var.iam_kops_policy)
    policy_arn = var.iam_kops_policy[count.index]
}

resource "aws_iam_policy_attachment" "route53-policy-attach" {
    name    = "route53-policy-attach"
    groups  = [aws_iam_group.kops-iamgroup.name]
    policy_arn  = aws_iam_policy.route53-user-policy.arn
}


# Create user kops
resource "aws_iam_user" "kops" {
    name    = "kops"
}

# Add user kops to group kops
resource "aws_iam_group_membership" "kopsgroup-membership" {
    name    = "kopsgroup-membership"
    users   = [aws_iam_user.kops.name]
    group   = aws_iam_group.kops-iamgroup.name
}

resource "aws_iam_access_key" "kops-access-key" {
    user    = aws_iam_user.kops.name
}

# Get access key for kops user
output "id" {
  value = aws_iam_access_key.kops-access-key.id
}

# Get secret key for kops
output "aws_iam_smtp_password_v4" {
    value = aws_iam_access_key.kops-access-key.ses_smtp_password_v4
}

# Print access key to a file
resource "null_resource" "set-access-iam-variables" {
    provisioner "local-exec" {
        command = "echo ${aws_iam_access_key.kops-access-key.id} > ${var.dest_access_key}"
    }
}

# Print secret key to a file
resource "null_resource" "set-secret-iam-variables" {
    provisioner "local-exec" {
        command = "echo ${aws_iam_access_key.kops-access-key.secret} > ${var.dest_secret_key}"
    }
}

# Create poilicy to change DNS setups
resource "aws_iam_policy" "route53-user-policy" {
    name = "eksuser-AmazonRoute53Domains-cert-manager"
    description = "Policy required by cert-manager to be able to modify Route 53 when generating wildcard certificates using Lets Encrypt"
    policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
    {
    "Effect": "Allow",
    "Action": "route53:GetChange",
    "Resource": "arn:aws:route53:::change/*"
    },
    {
    "Effect": "Allow",
    "Action": "route53:ChangeResourceRecordSets",
    "Resource": "arn:aws:route53:::hostedzone/*"
    },
    {
    "Effect": "Allow",
    "Action": "route53:ListHostedZonesByName",
    "Resource": "*"
    }
]
}
EOF
}



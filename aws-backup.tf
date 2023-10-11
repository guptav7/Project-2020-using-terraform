resource "aws_backup_plan" "ec2-backup" {
  name = "tf_ec2_backup_plan"

  rule {
    rule_name         = "tf_ec2_backup_rule"
    target_vault_name = aws_backup_vault.ec2-vault.name
    schedule          = "cron(0 1 * * ? *)"
  }
}

resource "aws_backup_vault" "ec2-vault" {
  name        = "ec2_backup_vault"
  
}

resource "aws_iam_role" "ec2-backup-tf-role" {
  name               = "ec2-backup-tf"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole"],
      "Effect": "allow",
      "Principal": {
        "Service": ["backup.amazonaws.com"]
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "role-attach-tf" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.ec2-backup-tf-role.name
}

resource "aws_backup_selection" "resource-selection" {
  iam_role_arn = aws_iam_role.ec2-backup-tf-role.arn
  name         = "tf_resource_backup_selection"
  plan_id      = aws_backup_plan.ec2-backup.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "Name"
    value = "ec2"
  }
}
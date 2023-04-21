resource "aws_iam_role" "devops-test-ssm-ec2-role" {
  name               = "devops-test-ssm-ec2-role-${var.CandidateName}"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": {
      "Effect": "Allow",
      "Principal": {"Service": "ec2.amazonaws.com"},
      "Action": "sts:AssumeRole"
    }
  }
EOF
}

resource "aws_iam_role_policy_attachment" "devops-test-ssm-ec2-role-attachment1" {
  role       = aws_iam_role.devops-test-ssm-ec2-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "devops-test-ssm-ec2-role-attachment2" {
  role       = aws_iam_role.devops-test-ssm-ec2-role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

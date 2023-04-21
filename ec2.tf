###
### AMI
###

data "aws_ami" "amazonlinux-ami" {
  owners      = ["amazon"]
  most_recent = true
  # name_regex = "amazonlinux"

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

###
### Security Group
###
resource "aws_security_group" "devops-test-sg-vms" {
  name        = "devops-test-sg-vms-${var.CandidateName}"
  description = "Allow HTTP Traffic to the DevOps Test ASG VMs from the VPC"
  vpc_id      = aws_vpc.devops-test-vpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.devops-test-vpc.cidr_block]
  }

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.devops-test-vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-test-sg-vms-${var.CandidateName}"
  }
}

###
### Auto Scaling Group
###
resource "aws_iam_instance_profile" "devops-test-asg-instance-profile" {
  name = "devops-test-instance-profile-${var.CandidateName}"
  role = aws_iam_role.devops-test-ssm-ec2-role.name
}

resource "aws_launch_template" "devops-test-asg-template" {
  name_prefix   = "devops-test-template-${var.CandidateName}"
  image_id      = data.aws_ami.amazonlinux-ami.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.devops-test-sg-vms.id]

  user_data = filebase64("${path.module}/user_data.sh")

  iam_instance_profile {
    name = aws_iam_instance_profile.devops-test-asg-instance-profile.name
  }

  tags = {
    Name = "devops-test-asg-template-${var.CandidateName}"
  }
}

resource "aws_autoscaling_group" "devops-test-asg" {
  name                      = "asg-terraform-apache-${var.CandidateName}"
  max_size                  = 3
  desired_capacity          = 1
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  vpc_zone_identifier       = [aws_subnet.devops-test-private-subnet-1a.id, aws_subnet.devops-test-private-subnet-1b.id]

  launch_template {
    id      = aws_launch_template.devops-test-asg-template.id
    version = "$Latest"
  }

  depends_on = [aws_launch_template.devops-test-asg-template]

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
}

resource "aws_autoscaling_attachment" "devops-test-asg-alb-attachment" {
  autoscaling_group_name = aws_autoscaling_group.devops-test-asg.id
  alb_target_group_arn   = aws_lb_target_group.devops-test-alb-tg.arn
}
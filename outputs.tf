output "alb_dns_name" {
  value = aws_lb.devops-test-alb.dns_name
}

output "amazonlinux_ami_id" {
  value = data.aws_ami.amazonlinux-ami.id
}
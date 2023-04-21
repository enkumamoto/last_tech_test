###
### Security Group
###
resource "aws_security_group" "devops-test-sg-alb" {
  name        = "devops-test-sg-alb-${var.CandidateName}"
  description = "Allow HTTP Traffic to DevOps Test ALB from the Internet"
  vpc_id      = aws_vpc.devops-test-vpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-test-sg-alb-${var.CandidateName}"
  }
}

###
### Application Load Balancer
###
resource "aws_lb" "devops-test-alb" {
  name               = "devops-test-alb-${var.CandidateName}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.devops-test-sg-alb.id]
  subnets            = [aws_subnet.devops-test-public-subnet-1a.id, aws_subnet.devops-test-public-subnet-1b.id]
}

resource "aws_lb_target_group" "devops-test-alb-tg" {
  name     = "devops-test-alb-tg-${var.CandidateName}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.devops-test-vpc.id
}

resource "aws_lb_listener" "devops-test-alb-listener-http" {
  load_balancer_arn = aws_lb.devops-test-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    # target_group_arn = aws_lb.devops-test-alb.arn

    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  # default_action {
  #   type             = "forward"
  #   target_group_arn = aws_lb_target_group.devops-test-alb-tg.arn
  # }
}

resource "aws_lb_target_group" "devop-test-alb-tg" {
  name     = "devop-test-alb-tg-${var.CandidateName}"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = aws_vpc.devops-test-vpc.id
}

resource "aws_lb_listener" "devops-test-alb-listener-https" {
  load_balancer_arn = aws_lb.devops-test-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = aws_acm_certificate.devops-test-self-sign-acm.arn



  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.devops-test-alb-tg.arn
  }
}
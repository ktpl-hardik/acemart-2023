resource "aws_security_group" "base_alb_sg" {
  name        = "${var.acemart_prod_owner}-base-alb-sg"
  description = "Allow HTTP traffic to Base instances through Base Application Load Balancer."
  vpc_id = aws_vpc.vpc.id

  ingress = [
    {
      description      = "HTTP global allow"
      protocol         = var.acemart_prod_sg_ingress_proto
      from_port        = var.acemart_prod_sg_ingress_http
      to_port          = var.acemart_prod_sg_ingress_http
      cidr_blocks      = [var.acemart_prod_sg_ingress_cidr_block_ipv4]
      ipv6_cidr_blocks = [var.acemart_prod_sg_ingress_cidr_block_ipv6]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "HTTPs global allow"
      protocol         = var.acemart_prod_sg_ingress_proto
      from_port        = var.acemart_prod_sg_ingress_https
      to_port          = var.acemart_prod_sg_ingress_https
      cidr_blocks      = [var.acemart_prod_sg_ingress_cidr_block_ipv4]
      ipv6_cidr_blocks = [var.acemart_prod_sg_ingress_cidr_block_ipv6]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
  egress = [
    {
      description      = "All traffic"
      protocol         = var.acemart_prod_sg_egress_proto
      from_port        = var.acemart_prod_sg_egress_all
      to_port          = var.acemart_prod_sg_egress_all
      cidr_blocks      = [var.acemart_prod_sg_egress_cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    "Name" = "${var.acemart_prod_owner}-base-alb-sg"
    "Environmnet" = "Production"
    "Terraform"   = "true"   
  }
}

# Create a basic ALB 
resource "aws_lb" "base_alb" {
  name               = "${var.acemart_prod_owner}-base-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.base_alb_sg.id]
  subnets            = [for subnet in aws_subnet.subnet : subnet.id]

  tags = {
    "Name" = "${var.acemart_prod_owner}-base-alb"
    "Environment" = "production"
    "Terraform"   = "true"       
  }
}

# Create target groups with one health check per group
resource "aws_lb_target_group" "base_target" {
  name = "${var.acemart_prod_owner}-base-target"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.vpc.id

  lifecycle { create_before_destroy=true }

  health_check {
    path = "/"
    port = 80
    healthy_threshold = 6
    unhealthy_threshold = 2
    timeout = 2
    interval = 5
    matcher = "200-302"
  }
}

# Create a Listener - HTTP
resource "aws_lb_listener" "base_alb_listener" {
  default_action {
    target_group_arn  = "${aws_lb_target_group.base_target.arn}"
    type              = "forward"
  }
  load_balancer_arn   = "${aws_lb.base_alb.arn}"
  port                = "80"
  protocol            = "HTTP"
}

# Create a Listener - HTTPS
resource "aws_lb_listener" "base_alb_listener_https" {
  default_action {
    target_group_arn  = "${aws_lb_target_group.base_target.arn}"
    type              = "forward"
  }
  load_balancer_arn = "${aws_lb.base_alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = "arn:aws:acm:us-east-1:997753278599:certificate/e7d2d80a-9efb-4758-8069-b8b6d968c4c1" #Certificate rn should be update accoring to setup.
}

# Create Listener Rules
#resource "aws_lb_listener_rule" "base_rule_1" {
#  action {
#    target_group_arn = "${aws_lb_target_group.base_target.arn}"
#    type = "forward"
#  }
#
#    condition {
#    path_pattern {
#      values = ["/"]
#    }
#  }
#
#  listener_arn = "${aws_lb_listener.base_alb_listener.id}"
#  priority = 100
#}

#Note:
#Base ALB SG add to the job-2-security_group.tf
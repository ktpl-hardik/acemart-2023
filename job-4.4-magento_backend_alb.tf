resource "aws_security_group" "magento_backend_alb_sg" {
  name        = "${var.acemart_prod_owner}-magento-backend-alb-sg"
  description = "Allow HTTP traffic to backend instances through backend Application Load Balancer."
  vpc_id = aws_vpc.vpc.id

  ingress = [
    {
      description      = "NV public IP"
      protocol         = var.acemart_prod_sg_ingress_proto
      from_port        = var.acemart_prod_sg_ingress_ssh
      to_port          = var.acemart_prod_sg_ingress_ssh
      cidr_blocks      = ["${chomp(data.http.myip.response_body)}/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },      
    {
      description      = "KTPL public IP"
      protocol         = var.acemart_prod_sg_ingress_proto
      from_port        = var.acemart_prod_sg_ingress_ssh
      to_port          = var.acemart_prod_sg_ingress_ssh
      cidr_blocks      = ["202.131.115.176/29"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
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
    },
    {
      description      = "SSH from Acemart Corporate LB IP - 1"
      protocol         = var.acemart_prod_sg_ingress_proto
      from_port        = var.acemart_prod_sg_ingress_ssh
      to_port          = var.acemart_prod_sg_ingress_ssh
      cidr_blocks      = ["64.132.229.66/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "SSH from Acemart Corporate LB IP - 2"
      protocol         = var.acemart_prod_sg_ingress_proto
      from_port        = var.acemart_prod_sg_ingress_ssh
      to_port          = var.acemart_prod_sg_ingress_ssh
      cidr_blocks      = ["184.80.232.34/32"]
      ipv6_cidr_blocks = []
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
    "Name" = "${var.acemart_prod_owner}-magento-backend-alb-sg"
    "Environmnet" = "Production"
    "Terraform"   = "true"   
  }
}

# Create a basic ALB 
resource "aws_lb" "magento_backend_alb" {
  name               = "${var.acemart_prod_owner}-magento-backend-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.magento_backend_alb_sg.id]
  subnets            = [for subnet in aws_subnet.subnet : subnet.id]

  tags = {
    "Name" = "${var.acemart_prod_owner}-magento-backend-alb"
    "Environment" = "Production"
    "Terraform"   = "true"       
  }
}

# Create target groups with one health check per group
resource "aws_lb_target_group" "magento_backend_target" {
  name = "${var.acemart_prod_owner}-magento-backend-target"
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

  tags = {
    "Name" = "${var.acemart_prod_owner}-magento-backend-target"
    "Environment" = "Production"
    "Terraform"   = "true"       
  }
}

# Create target groups with one health check per group
resource "aws_lb_target_group" "magento_admin_target" {
  name = "${var.acemart_prod_owner}-magento-admin-target"
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

  tags = {
    "Name" = "${var.acemart_prod_owner}-magento-admin-target"
    "Environment" = "Production"
    "Terraform"   = "true"       
  }
}

# Create a Listener - HTTP
resource "aws_lb_listener" "magento_backend_alb_listener_http" {
  default_action {
    target_group_arn  = "${aws_lb_target_group.magento_backend_target.arn}"
    type              = "forward"
  }
  load_balancer_arn   = "${aws_lb.magento_backend_alb.arn}"
  port                = "80"
  protocol            = "HTTP"
}

# Create a Listener - HTTPS
resource "aws_lb_listener" "magento_backend_alb_listener_https" {
  default_action {
    target_group_arn  = "${aws_lb_target_group.magento_backend_target.arn}"
    type              = "forward"
  }
  load_balancer_arn = "${aws_lb.magento_backend_alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = "arn:aws:acm:us-east-1:997753278599:certificate/e7d2d80a-9efb-4758-8069-b8b6d968c4c1" #Certificate arn should be update accoring to setup.
}

# Create a Listener Admin - HTTP
resource "aws_lb_listener" "magento_admin_alb_listener_http" {
  default_action {
    target_group_arn  = "${aws_lb_target_group.magento_admin_target.arn}"
    type              = "forward"
  }
  load_balancer_arn   = "${aws_lb.magento_backend_alb.arn}"
  port                = "80"
  protocol            = "HTTP"
}

# Create a Listener Admin - HTTPS
resource "aws_lb_listener" "magento_admin_alb_listener_https" {
  default_action {
    target_group_arn  = "${aws_lb_target_group.magento_admin_target.arn}"
    type              = "forward"
  }
  load_balancer_arn = "${aws_lb.magento_backend_alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = "arn:aws:acm:us-east-1:997753278599:certificate/e7d2d80a-9efb-4758-8069-b8b6d968c4c1" #Certificate ar
}

resource "aws_lb_listener_rule" "rule_1" {
  listener_arn = "${aws_lb_listener.magento_backend_alb_listener_http.arn}"
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.magento_backend_target.arn}"
  }

  condition {
    path_pattern {
      values = ["/magmi/web/*"]
    }
  }
}

resource "aws_lb_listener_rule" "rule_2" {
  listener_arn = "${aws_lb_listener.magento_backend_alb_listener_http.arn}"
  priority     = 3

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.magento_backend_target.arn}"
  }

  condition {
    path_pattern {
      values = ["/dbs/*"]
    }
  }
}

resource "aws_lb_listener_rule" "rule_3" {
  listener_arn = "${aws_lb_listener.magento_backend_alb_listener_http.arn}"
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.magento_backend_target.arn}"
  }

  condition {
    path_pattern {
      values = ["/admin_*"]
    }
  }
}


resource "aws_lb_listener_rule" "rule_4" {
  listener_arn = "${aws_lb_listener.magento_backend_alb_listener_https.arn}"
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.magento_backend_target.arn}"
  }

  condition {
    path_pattern {
      values = ["/magmi/web/*"]
    }
  }
}

resource "aws_lb_listener_rule" "rule_5" {
  listener_arn = "${aws_lb_listener.magento_backend_alb_listener_https.arn}"
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.magento_backend_target.arn}"
  }

  condition {
    path_pattern {
      values = ["/dbs/*"]
    }
  }
}

resource "aws_lb_listener_rule" "rule_6" {
  listener_arn = "${aws_lb_listener.magento_backend_alb_listener_https.arn}"
  priority     = 3

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.magento_backend_target.arn}"
  }

  condition {
    path_pattern {
      values = ["/admin_*"]
    }
  }
}

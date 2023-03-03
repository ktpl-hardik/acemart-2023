# Create AWS Launch Configuration.
resource "aws_launch_configuration" "magento_backend" {
  name = "${var.acemart_prod_owner}-magento-backend"

  image_id       = var.acemart_prod_magento_instance_ami
  instance_type  = var.acemart_prod_magento_instance_type
  key_name       = var.acemart_prod_key_pair

  security_groups = [aws_security_group.magento_backend_alb_sg.id]
  associate_public_ip_address = true

#  user_data = <<EOF
##!/bin/bash
#sudo apt-get update
#sudo apt-get install -y apache2
#sudo systemctl start apache2
#sudo systemctl enable apache2
#echo "<h1>Deployed via Terraform - request from Magento backend - $(hostname)</h1>" | sudo tee /var/www/html/index.html
#EOF

  lifecycle {
    create_before_destroy = true
  }
}

# Create an ASG that ties all of this together.
resource "aws_autoscaling_group" "magento_backend_asg" {
  name = "${aws_launch_configuration.magento_backend.name}-asg"
  desired_capacity  = "1"
  min_size          = "1"
  max_size          = "4"
  launch_configuration = "${aws_launch_configuration.magento_backend.name}"  #Default LC launch by default or above resource
  #launch_configuration  = "acemart_prod_2023-magento-backend"                              #Mentationed explicitly after create new LC manually from AWS Console UI. 
  vpc_zone_identifier = [for subnet in aws_subnet.subnet : subnet.id]

  tag {
    key                 = "Name"
    value               = "${aws_launch_configuration.magento_backend.name}-asg"
    propagate_at_launch = true
  }

    termination_policies = [
    "OldestInstance",
    "OldestLaunchConfiguration",
  ]
  
  health_check_type = "ELB"

  depends_on = [aws_lb.magento_backend_alb]

  target_group_arns = [
    "${aws_lb_target_group.magento_backend_target.arn}",
  ]

  lifecycle {
    create_before_destroy = true
  }
}
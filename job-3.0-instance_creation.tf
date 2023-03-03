data "aws_subnet_ids" "acemart_prod_subnet_1" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.acemart_prod_owner}-subnet-1"
  }
}

data "aws_availability_zones" "available_az" {}
#################################################
#output "instance_id" {
#  description       = "ID of the EC2 instance"
#  value             = aws_instance.nfs_instance[each.key].id 
#}
#
#output "instance_public_ip" {
#  description = "Public IP address of the EC2 instance"
#  value       = aws_instance.nfs_instance.public_ip
#}
#################################################

################ Bastion-Instance ###############
#################################################
resource "aws_instance" "bastion_instance" {
  for_each          = data.aws_subnet_ids.acemart_prod_subnet_1.ids
  availability_zone = element(data.aws_availability_zones.available_az.names, 0)
  ami               = var.acemart_prod_instance_ami
  ##  availability_zone           = "${var.acemart_prod_aws_region}${var.acemart_prod_aws_region_az}"
  instance_type               = var.acemart_prod_bastion_instance_type
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  subnet_id                   = each.value
  ##  count                       = "${length(data.aws_subnet_ids.acemart_prod_subnet_1.ids)}"
  ##  subnet_id                   = "${tolist(data.aws_subnet_ids.acemart_prod_subnet_1.ids)[count.index]}"   
  key_name = var.acemart_prod_key_pair

  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = var.acemart_prod_root_device_size
    volume_type           = var.acemart_prod_root_device_type
    tags = {
      Name = "${var.acemart_prod_owner}-bastion-volume"
    }
  }

  tags = {
    "Owner"               = var.acemart_prod_owner
    "Name"                = "${var.acemart_prod_owner}-bastion-instance"
    "Environmnet"         = "Production"
    "KeepInstanceRunning" = "false"
    "Terraform"           = "true"
  }
}

################ Base-Instance ###############
#############################################
resource "aws_instance" "base_instance" {
  for_each                    = data.aws_subnet_ids.acemart_prod_subnet_1.ids
  availability_zone           = element(data.aws_availability_zones.available_az.names, 0)
  ami                         = var.acemart_prod_instance_ami
  instance_type               = var.acemart_prod_base_instance_type
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.base_sg.id]
  subnet_id                   = each.value
  key_name                    = var.acemart_prod_key_pair

  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = var.acemart_prod_root_device_size
    volume_type           = var.acemart_prod_root_device_type
    tags = {
      Name = "${var.acemart_prod_owner}-base-volume"
    }
  }

  tags = {
    "Owner"               = var.acemart_prod_owner
    "Name"                = "${var.acemart_prod_owner}-base-instance"
    "Environmnet"         = "Production"
    "KeepInstanceRunning" = "false"
    "Terraform"           = "true"
  }
}

################ MySQL-Instance ###############
#############################################
resource "aws_instance" "mysql_instance" {
  for_each                    = data.aws_subnet_ids.acemart_prod_subnet_1.ids
  availability_zone           = element(data.aws_availability_zones.available_az.names, 0)
  ami                         = var.acemart_prod_instance_ami
  instance_type               = var.acemart_prod_mysql_instance_type
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.mysql_sg.id]
  subnet_id                   = each.value
  key_name                    = var.acemart_prod_key_pair

  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = var.acemart_prod_root_device_size
    volume_type           = var.acemart_prod_root_device_type
    tags = {
      Name = "${var.acemart_prod_owner}-mysql-volume"
    }
  }

  tags = {
    "Owner"               = var.acemart_prod_owner
    "Name"                = "${var.acemart_prod_owner}-mysql-instance"
    "Environmnet"         = "Production"
    "KeepInstanceRunning" = "false"
    "Terraform"           = "true"
  }
}

################ Elasticsearch and Redis-Instance ###############
#################################################################
resource "aws_instance" "cache_instance" {
  for_each                    = data.aws_subnet_ids.acemart_prod_subnet_1.ids
  availability_zone           = element(data.aws_availability_zones.available_az.names, 0)
  ami                         = var.acemart_prod_instance_ami
  instance_type               = var.acemart_prod_cache_instance_type
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.cache_sg.id]
  subnet_id                   = each.value
  key_name                    = var.acemart_prod_key_pair

  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = var.acemart_prod_root_device_size
    volume_type           = var.acemart_prod_root_device_type
    tags = {
      Name = "${var.acemart_prod_owner}-cache-volume"
    }
  }

  tags = {
    "Owner"               = var.acemart_prod_owner
    "Name"                = "${var.acemart_prod_owner}-cache-instance"
    "Environmnet"         = "Production"
    "KeepInstanceRunning" = "false"
    "Terraform"           = "true"
  }
}

################ PWA-Instance ###############
#################################################################
resource "aws_instance" "pwa_instance" {
  for_each                    = data.aws_subnet_ids.acemart_prod_subnet_1.ids
  availability_zone           = element(data.aws_availability_zones.available_az.names, 0)
  ami                         = var.acemart_prod_instance_ami
  instance_type               = var.acemart_prod_pwa_instance_type
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.pwa_sg.id]
  subnet_id                   = each.value
  key_name                    = var.acemart_prod_key_pair

  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = var.acemart_prod_root_device_size
    volume_type           = var.acemart_prod_root_device_type
    tags = {
      Name = "${var.acemart_prod_owner}-pwa-volume"
    }
  }

  tags = {
    "Owner"               = var.acemart_prod_owner
    "Name"                = "${var.acemart_prod_owner}-pwa-instance"
    "Environmnet"         = "Production"
    "KeepInstanceRunning" = "false"
    "Terraform"           = "true"
  }
}
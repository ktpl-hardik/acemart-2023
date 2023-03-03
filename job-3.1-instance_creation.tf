#data "aws_instance" "nfs_instance_1" {
#  instance_id = aws_instance.nfs_instance.*.id
#    filter {
#    name   = "Name"
#    values = ["nfs-instance"]
#  }
#}

#output "bastion_instance" {
#  value = "${tolist(aws_instance.bastion_instance.id)}"
#}

################ NFS-Instance ###############
#############################################
resource "aws_instance" "nfs_instance" {
  for_each                    = data.aws_subnet_ids.acemart_prod_subnet_1.ids
  availability_zone           = element(data.aws_availability_zones.available_az.names, 0)
  ami                         = var.acemart_prod_instance_ami
  instance_type               = var.acemart_prod_nfs_instance_type
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.nfs_sg.id]
  subnet_id                   = each.value
  key_name                    = var.acemart_prod_key_pair

  user_data = <<EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install -y net-tool
sudo apt-get install -y nfs-kernel-server
EOF

  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = var.acemart_prod_root_device_size
    volume_type           = var.acemart_prod_root_device_type
    tags = {
      Name = "${var.acemart_prod_owner}-nfs-volume"
    }
  }

  tags = {
    "Owner"               = var.acemart_prod_owner
    "Name"                = "${var.acemart_prod_owner}-nfs-instance"
    "Environmnet"         = "Production"
    "KeepInstanceRunning" = "false"
  }
}

resource "aws_ebs_volume" "app_ebs" {
  availability_zone = element(data.aws_availability_zones.available_az.names, 0)
  size              = 50
  type              = var.acemart_prod_ebs_device_type
  tags = {
    "Owner"       = var.acemart_prod_owner
    "Name"        = "${var.acemart_prod_owner}-app-volume"
    "Environmnet" = "Production"
    "Terraform"   = "true"
  }
}
######## Manual Step to add instance ID for each operations ########
resource "aws_volume_attachment" "app_ebs_vol" {
# for_each     = data.aws_subnet_ids.mspl_subnet_1.ids
#for_each     = data.aws_instance.nfs_instance_1.ids
 device_name  = "/dev/sdh"
 volume_id    = "${aws_ebs_volume.app_ebs.id}"
# instance_id  = "${aws_instance.nfs_instance_1.id}"
# instance_id   = "${length(data.aws_instance.nfs_instance_1)}"
 instance_id   =  "i-0fad48f072868c75a"
}

resource "aws_eip" "bastion_instance_eip" {
  instance = "i-043b61da6f3d7f536"
  vpc      = true

  tags = {
    "Owner"               = var.acemart_prod_owner
    "Name"                = "${var.acemart_prod_owner}-bastion-instance"
    "Environmnet"         = "Production"
    "KeepInstanceRunning" = "false"
  }
}

resource "aws_eip" "base_instance_eip" {
  instance = "i-0e2ecb28c06db9b53"
  vpc      = true

  tags = {
    "Owner"               = var.acemart_prod_owner
    "Name"                = "${var.acemart_prod_owner}-base-instance"
    "Environmnet"         = "Production"
    "KeepInstanceRunning" = "false"
  }  
}

resource "aws_eip" "nfs_instance_eip" {
  instance = "i-0fad48f072868c75a"
  vpc      = true

  tags = {
    "Owner"               = var.acemart_prod_owner
    "Name"                = "${var.acemart_prod_owner}-nfs-instance"
    "Environmnet"         = "Production"
    "KeepInstanceRunning" = "false"
  }  
}

resource "aws_eip" "mysql_instance_eip" {
  instance = "i-0414d7436a1751ca0"
  vpc      = true

  tags = {
    "Owner"               = var.acemart_prod_owner
    "Name"                = "${var.acemart_prod_owner}-mysql-instance"
    "Environmnet"         = "Production"
    "KeepInstanceRunning" = "false"
  }
}

resource "aws_eip" "cache_instance_eip" {
  instance = "i-01d3b76dfeb83cb11"
  vpc      = true

  tags = {
    "Owner"               = var.acemart_prod_owner
    "Name"                = "${var.acemart_prod_owner}-cache-instance"
    "Environmnet"         = "Production"
    "KeepInstanceRunning" = "false"
  }
}

resource "aws_eip" "pwa_instance_eip" {
  instance = "i-0b1bdb687a7d5ef91"
  vpc      = true

  tags = {
    "Owner"               = var.acemart_prod_owner
    "Name"                = "${var.acemart_prod_owner}-pwa-instance"
    "Environmnet"         = "Production"
    "KeepInstanceRunning" = "false"
  }
}

# resource "aws_eip" "magento_backend_asg_1_eip" {
  # vpc      = true

  # tags = {
    # "Owner"               = var.acemart_prod_owner
    # "Name"                = "${var.acemart_prod_owner}-magento-backend-asg-1"
    # "Environmnet"         = "Production"
    # "KeepInstanceRunning" = "false"
    # "Terraform"           = "Yes"
  # }
# }

# resource "aws_eip" "magento_backend_asg_2_eip" {
  # vpc      = true

  # tags = {
    # "Owner"               = var.acemart_prod_owner
    # "Name"                = "${var.acemart_prod_owner}-magento-backend-asg-2"
    # "Environmnet"         = "Production"
    # "KeepInstanceRunning" = "false"
    # "Terraform"           = "Yes"
  # }
# }

# resource "aws_eip" "magento_backend_asg_3_eip" {
  # vpc      = true

  # tags = {
    # "Owner"               = var.acemart_prod_owner
    # "Name"                = "${var.acemart_prod_owner}-magento-backend-asg-3"
    # "Environmnet"         = "Production"
    # "KeepInstanceRunning" = "false"
    # "Terraform"           = "Yes"
  # }
# } 

# resource "aws_eip" "magento_backend_asg_4_eip" {
  # vpc      = true

  # tags = {
    # "Owner"               = var.acemart_prod_owner
    # "Name"                = "${var.acemart_prod_owner}-magento-backend-asg-4"
    # "Environmnet"         = "Production"
    # "KeepInstanceRunning" = "false"
    # "Terraform"           = "Yes"
  # }
# } 
# resource "aws_eip" "magento_backend_asg_5_eip" {
  # vpc      = true

  # tags = {
    # "Owner"               = var.acemart_prod_owner
    # "Name"                = "${var.acemart_prod_owner}-magento-backend-asg-5"
    # "Environmnet"         = "Production"
    # "KeepInstanceRunning" = "false"
    # "Terraform"           = "Yes"
  # }
# } 
# resource "aws_eip" "magento_backend_asg_6_eip" {
  # vpc      = true

  # tags = {
    # "Owner"               = var.acemart_prod_owner
    # "Name"                = "${var.acemart_prod_owner}-magento-backend-asg-6"
    # "Environmnet"         = "Production"
    # "KeepInstanceRunning" = "false"
    # "Terraform"           = "Yes"
  # }  
# }

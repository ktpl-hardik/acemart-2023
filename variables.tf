# Variables for general information
######################################

variable "acemart_prod_owner" {
  description = "Configuration owner"
  type        = string
}


# Variables for region and az
######################################
variable "acemart_prod_aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "acemart_prod_aws_region_az" {
  description = "AWS region availability zone "
  type        = string
  default     = "a"
}

variable "acemart_prod_aws_region_azs" {
  type    = list(any)
  default = ["us-east-1a", "us-east-1b"]
}


# Variables for VPC and Subnet
######################################

variable "acemart_prod_vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.16.2.0/24"
}

variable "acemart_prod_sbn_cidr_block" {
  description = "CIDR block for the subnet"
  type        = list(any)
  default     = ["10.16.2.0/26", "10.16.2.64/26"]
}

variable "acemart_prod_vpc_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "acemart_prod_vpc_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "acemart_prod_sbn_public_ip" {
  description = "Assign public IP to the instance launched into the subnet"
  type        = bool
  default     = true
}


# Variables for Route Table
######################################

variable "acemart_prod_rt_cidr_block" {
  description = "CIDR block for the route table"
  type        = string
  default     = "0.0.0.0/0"
}


# Variables for Instance
######################################

variable "acemart_prod_instance_ami" {
  description = "ID of the AMI used"
  type        = string
  default     = "ami-09cd747c78a9add63"
}

variable "acemart_prod_magento_instance_ami" {
  description = "ID of the AMI used"
  type        = string
  default     = "ami-01b03b592028e9f6e"
}


variable "acemart_prod_bastion_instance_type" {
  description = "Type of the instance"
  type        = string
  default     = "t3.micro"
}

variable "acemart_prod_nfs_instance_type" {
  description = "Type of the instance"
  type        = string
  default     = "c5.xlarge"
}

variable "acemart_prod_base_instance_type" {
  description = "Type of the instance"
  type        = string
  default     = "c5.xlarge"
}

variable "acemart_prod_mysql_instance_type" {
  description = "Type of the instance"
  type        = string
  default     = "c5.xlarge"
}

variable "acemart_prod_magento_instance_type" {
  description = "Type of the instance"
  type        = string
  default     = "c5.xlarge"
}

variable "acemart_prod_cache_instance_type" {
  description = "Type of the instance"
  type        = string
  default     = "m5.large"
}

variable "acemart_prod_pwa_instance_type" {
  description = "Type of the instance"
  type        = string
  default     = "c5.xlarge"
}

variable "acemart_prod_instance_type" {
  description = "Type of the instance"
  type        = string
  default     = "t2.micro"
}

variable "acemart_prod_key_pair" {
  description = "SSH Key pair used to connect"
  type        = string
  default     = "Acemart-2023-key"
}

variable "acemart_prod_root_device_type_gp2" {
  description = "Type of the root block device"
  type        = string
  default     = "gp2"
}

variable "acemart_prod_root_device_type" {
  description = "Type of the root block device"
  type        = string
  default     = "gp3"
}

variable "acemart_prod_ebs_device_type" {
  description = "Type of the root block device"
  type        = string
  default     = "gp3"
}

variable "acemart_prod_root_device_size" {
  description = "Size of the root block device"
  type        = string
  default     = "50"
}

variable "acemart_prod_ebs_device_size" {
  description = "Size of the root block device"
  type        = string
  default     = "50"
}

variable "acemart_prod_asg_root_device_type" {
  description = "Type of the root block device"
  type        = string
  default     = "gp3"
}

variable "acemart_prod_asg_root_device_size" {
  description = "Size of the root block device"
  type        = string
  default     = "30"
}

#variable "domain_name" {
#  description = "servername of NFS Server"
#  type        = string
#}

#variable "instance_id" {
#  description = "Instance ID"
#  type        = string
#  default     = null
#}



# Variables for Security Group
######################################

variable "acemart_prod_sg_ingress_proto" {
  description = "Protocol used for the ingress rule"
  type        = string
  default     = "tcp"
}

variable "acemart_prod_sg_ingress_ssh" {
  description = "Port used for the ingress rule"
  type        = string
  default     = "22"
}

variable "acemart_prod_sg_ingress_http" {
  description = "Port used for the ingress rule"
  type        = string
  default     = "80"
}

variable "acemart_prod_sg_ingress_https" {
  description = "Port used for the ingress rule"
  type        = string
  default     = "443"
}

variable "acemart_prod_sg_ingress_node" {
  description = "Port used for the ingress rule"
  type        = string
  default     = "8080"
}

variable "acemart_prod_sg_ingress_nfs" {
  description = "Port used for the ingress rule"
  type        = string
  default     = "2049"
}

variable "acemart_prod_sg_ingress_mysql" {
  description = "Port used for the ingress rule"
  type        = string
  default     = "3306"
}

variable "acemart_prod_sg_ingress_redis" {
  description = "Port used for the ingress rule"
  type        = string
  default     = "6379"
}

variable "acemart_prod_sg_ingress_elasticsearch" {
  description = "Port used for the ingress rule"
  type        = string
  default     = "9200"
}

variable "acemart_prod_sg_ingress_cidr_block" {
  description = "CIDR block for the egress rule"
  type        = string
  default     = "0.0.0.0/0"
}

variable "acemart_prod_sg_ingress_cidr_block_ipv4" {
  description = "CIDR block for the egress rule"
  type        = string
  default     = "0.0.0.0/0"
}

variable "acemart_prod_sg_ingress_cidr_block_ipv6" {
  description = "CIDR block for the egress rule"
  type        = string
  default     = "::/0"
}

variable "acemart_prod_sg_egress_proto" {
  description = "Protocol used for the egress rule"
  type        = string
  default     = "-1"
}

variable "acemart_prod_sg_egress_all" {
  description = "Port used for the egress rule"
  type        = string
  default     = "0"
}

variable "acemart_prod_sg_egress_cidr_block" {
  description = "CIDR block for the egress rule"
  type        = string
  default     = "0.0.0.0/0"
}

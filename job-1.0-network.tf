#### 1. Create Custom VPC ####
resource "aws_vpc" "vpc" {
  cidr_block           = var.acemart_prod_vpc_cidr_block
  enable_dns_hostnames = var.acemart_prod_vpc_dns_hostnames
  enable_dns_support   = var.acemart_prod_vpc_dns_support

  tags = {
    "Owner"     = var.acemart_prod_owner
    "Name"      = "${var.acemart_prod_owner}-vpc"
    "Terraform" = "true"
  }
}

#### 2. Create Subnet ####
resource "aws_subnet" "subnet" {
  count                   = length(var.acemart_prod_sbn_cidr_block)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.acemart_prod_sbn_cidr_block, count.index)
  availability_zone       = element(var.acemart_prod_aws_region_azs, count.index)
  map_public_ip_on_launch = var.acemart_prod_sbn_public_ip

  tags = {
    "Owner"     = var.acemart_prod_owner
    "Name"      = "${var.acemart_prod_owner}-subnet-${count.index + 1}"
    "Terraform" = "true"
  }
}

#### 3. Create Internet Gateway ####
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Owner"     = var.acemart_prod_owner
    "Name"      = "${var.acemart_prod_owner}-igw"
    "Terraform" = "true"
  }
}

#### 4. Create Route Table ####
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.acemart_prod_rt_cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    "Owner"     = var.acemart_prod_owner
    "Name"      = "${var.acemart_prod_owner}-rt"
    "Terraform" = "true"
  }

}

#### 5. Create Route Table Assocaition ####
resource "aws_route_table_association" "acemart_prod_rt_sbn_asso" {
  count          = length(var.acemart_prod_sbn_cidr_block)
  subnet_id      = element(aws_subnet.subnet.*.id, count.index)
  route_table_id = aws_route_table.rt.id
}
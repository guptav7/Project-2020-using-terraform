resource "aws_vpc" "myterraformvpc" {
  cidr_block       = "176.85.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "DEMO-TF-VPC"
  }
}

resource "aws_subnet" "publicsubnet" {
map_public_ip_on_launch = true
  vpc_id     = "${aws_vpc.myterraformvpc.id}"
  cidr_block = "176.85.2.0/24"
availability_zone = "us-east-1a"
  tags = {
    Name = "PublicSubnet-Terraform VPC"
  }
}

resource "aws_subnet" "publicsubnet1" {
map_public_ip_on_launch = true
  vpc_id     = "${aws_vpc.myterraformvpc.id}"
  cidr_block = "176.85.3.0/24"
availability_zone = "us-east-1b"
  tags = {
    Name = "PublicSubnet1-Terraform VPC 2"
  }
}

resource "aws_subnet" "privatesubnet" {
map_public_ip_on_launch = true
  vpc_id     = "${aws_vpc.myterraformvpc.id}"
  cidr_block = "176.85.0.0/24"
availability_zone = "us-east-1c"
  tags = {
    Name = "PrivateSubnet-Terraform VPC 2"
  }
}

resource "aws_subnet" "privatesubnet1" {
map_public_ip_on_launch = true
  vpc_id     = "${aws_vpc.myterraformvpc.id}"
  cidr_block = "176.85.1.0/24"
availability_zone = "us-east-1d"
  tags = {
    Name = "PrivateSubnet1-Terraform VPC 2"
  }
}

resource "aws_nat_gateway" "NGW" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.publicsubnet.id

  tags = {
    Name = "NG-Terraform"
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_internet_gateway" "myinternetgw" {
  vpc_id = "${aws_vpc.myterraformvpc.id}"

  tags = {
    Name = "IG-Terraform-VPC"
  }
}
resource "aws_route_table" "Public-tf-routetable" {
  vpc_id = "${aws_vpc.myterraformvpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.myinternetgw.id}"
  }

  tags = {
    Name = "Public-Route-Terraform VPC"
  }
  
  }
 resource "aws_route_table" "Private-tf-routetable" {
  vpc_id = "${aws_vpc.myterraformvpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.NGW.id}"
  }

  tags = {
    Name = "Private-Route-Terraform VPC"
  } 
}
resource "aws_route_table_association" "myroutetableassociation" {
subnet_id            = aws_subnet.publicsubnet.id
  route_table_id = "${aws_route_table.Public-tf-routetable.id}"
}
resource "aws_route_table_association" "myroutetableassociationb" {
subnet_id            = aws_subnet.publicsubnet1.id
  route_table_id = "${aws_route_table.Public-tf-routetable.id}"
}
resource "aws_route_table_association" "private-routetableassociation" {
subnet_id           = aws_subnet.privatesubnet.id
  route_table_id = "${aws_route_table.Private-tf-routetable.id}"
}
resource "aws_route_table_association" "private-routetableassociationb" {
subnet_id           = aws_subnet.privatesubnet1.id
  route_table_id = "${aws_route_table.Private-tf-routetable.id}"
}



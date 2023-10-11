resource "aws_ami_from_instance" "ami-tf" {
  name               = "terraform-amit"
  source_instance_id = "${aws_instance.my-tf-ec2.id}"
  depends_on = ["aws_instance.my-tf-ec2"]
}


resource "aws_instance" "my-tf-ec2" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  key_name      = "NorthVirginiaKey"
subnet_id = "${aws_subnet.publicsubnet.id}"
security_groups = ["${aws_security_group.project-securitygroup.id}"]
  tags = {
    Name = "My-terraform"
  }
  user_data =  templatefile("userdatahttpd.tpl",{})
 }  
  
  
  resource "aws_security_group" "project-securitygroup" {
  name        = "AllTraffic"
  description = "AllTraffic Allowed"
  vpc_id      = "${aws_vpc.myterraformvpc.id}"

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

ingress {
    description = "Http from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["176.85.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Onlyhttp"
  }
}
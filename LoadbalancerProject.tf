resource "aws_security_group" "all-securitygroup-lb" {
  name        = "AllTraffic-TF"
  description = "AllTraffic Allowed"
  vpc_id      = "${aws_vpc.myterraformvpc.id}"

  ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "AllTraffic-TF"
  }
}

resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.all-securitygroup-lb.id}"]
  subnets            = ["${aws_subnet.publicsubnet.id}","${aws_subnet.publicsubnet1.id}"]

  tags = {
    Environment = "dev"
  }
}

resource "aws_lb_target_group" "tf-tg" {
  name     = "tf-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.myterraformvpc.id}"
  health_check {
  
  interval = 6
  path = "/index.html"
  port = 80
  protocol = "HTTP"
  timeout = 3
  healthy_threshold = 2
  unhealthy_threshold = 3
 } 
  depends_on = ["aws_lb.test"]
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = "${aws_lb.test.arn}"
  port              = "80"
  protocol          = "HTTP"
#ssl_policy        = "ELBSecurityPolicy-2016-08"
 # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.tf-tg.arn}"
  }
  }
##providers

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.69.0"
    }
  }
}

provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

##Create Launch configuration

resource "aws_launch_configuration" "lab-launch"{
  image_id      = "${lookup(var.ami_id, var.region)}"
  instance_type = var.instance_type
  iam_instance_profile = var.role_name
#  security_groups = ["sg-56ad5d5d"]
  key_name = var.key_name
  user_data = "${file("userdata.sh")}"
} 

##Create ASG in public subnet

resource "aws_autoscaling_group" "lab-asg"{
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  launch_configuration      = aws_launch_configuration.lab-launch.name
  vpc_zone_identifier       = [var.pubsub_id]
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "web"
    propagate_at_launch = true
  }
}

##Create Ec2 instance on private subnet

resource "aws_instance" "db" {
  ami           = "${lookup(var.ami_id, var.region)}"
  instance_type = var.instance_type
  subnet_id     = var.privsub_id
#  vpc_security_group_ids = ["var.db_sg"]
  key_name = var.key_name
  user_data = "${file("userdata1.sh")}"
tags = {
    Name = "database"
}  
}

  
## create classic LB in pub_sub and attch ASG

resource "aws_security_group" "elb_http" {
  name        = "elb_http"
  description = "Allow HTTP traffic to instances through Elastic Load Balancer"
  vpc_id = "vpc-049e862436a18dbcf"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow HTTP through ELB Security Group"
  }
}

resource "aws_elb" "web_elb" {
  name = "web-elb"
  security_groups = [aws_security_group.elb_http.id]
  subnets = [var.pubsub_id]
  cross_zone_load_balancing   = true

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
  }

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "80"
    instance_protocol = "http"
  }

}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.lab-asg.id
  elb                    = aws_elb.web_elb.id
}

output "elb_dns_name" {
  value = aws_elb.web_elb.dns_name
}















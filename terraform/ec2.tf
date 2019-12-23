data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "cloud-init-file" {
  template = "${file("templates/cloud-init.yml.tpl")}"
}

data "template_file" "user-data-file" {
  template = "${file("templates/user-data.yml.tpl")}"
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "cloud-config.txt"
    content_type = "text/cloud-config"
    content      = "${data.template_file.cloud-init-file.rendered}"
  }

  part {
    filename     = "userdata.txt"
    content_type = "text/x-shellscript"
    content      = "${data.template_file.user-data-file.rendered}"
  }

}

resource "aws_security_group" "lc_sg" {
  name = "lc-sg"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "web_app_lc" {
  name_prefix   		= "onica-lc-app-"
  image_id      		= data.aws_ami.ubuntu.id
  instance_type 		= "t2.micro"
  security_groups 	= ["${aws_security_group.lc_sg.id}"]
	user_data_base64 	= data.template_cloudinit_config.config.rendered

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web_asg" {
  name                 = "onica-web-app-asg"
  launch_configuration = aws_launch_configuration.web_app_lc.name
  availability_zones 	 = var.az_list
  load_balancers 			 = ["${aws_elb.web_elb.name}"]
  health_check_type 	 = "ELB"
  min_size             = 2
	desired_capacity     = 4
  max_size             = 10
	force_delete         = true

	tag {
    key 								= "Name"
    value 							= "Hello Web"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "elb_sg" {
  name = "elb-sg"

  egress {
    from_port 	= 0
    to_port 		= 0
    protocol 		= "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port 	= 80
    to_port 		= 80
    protocol 		= "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "web_elb" {
  name               	= var.elb_name
  availability_zones 	= var.az_list
  security_groups 		= ["${aws_security_group.elb_sg.id}"]

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "${var.elb_name}"
  }
}

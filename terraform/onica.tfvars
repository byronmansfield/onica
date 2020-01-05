region = "us-west-2"
profile = "onica"

environment = "dev"
application_name = "Onica Prototype"
application_slug = "onica"

vpc_cidr = "10.0.0.0/20"
az_list = ["us-west-2a", "us-west-2b", "us-west-2c"]
private_subnet_cidr_list = ["10.0.4.0/22", "10.0.8.0/22", "10.0.12.0/22"]
public_subnet_cidr_list  = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]

elb_name = "onica-hello-elb"
app_port = "5000"

key_name = "onica_ec2"

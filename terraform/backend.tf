terraform {
  backend "s3" {
    bucket = "terraform-onica"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

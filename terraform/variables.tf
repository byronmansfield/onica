variable "region" {
  type        = string
  description = "The aws region for the kubernetes cluster"
  default     = ""
}

variable "profile" {
  type        = string
  description = "IAM Profile name for Onica"
  default     = ""
}

## Project Metadata

variable "environment" {
  type        = string
  description = "The Environment of the Onica DevOps Exercise"
  default     = ""
}

variable "application_name" {
  type        = string
  description = "The Application Name of Onica DevOps Exercise"
  default     = ""
}

variable "application_slug" {
  type        = string
  description = "The Application Slug of the Onica DevOps Web App"
  default     = ""
}

## Network Specification

variable "vpc_cidr" {
  type        = string
  description = "The CIDR Range for the Onica DevOps App"
  default     = ""
}

variable "az_list" {
  type        = list(string)
  description = "The AZ of the Onica DevOps project will be placed in"
  default     = []
}

variable "private_subnet_cidr_list" {
  type        = list(string)
  description = "The CIDR list of the Onica DevOps instance will be placed in"
  default     = []
}

variable "public_subnet_cidr_list" {
  type        = list(string)
  description = "The CIDR list of the Onica DevOps web instances public pieces will be placed in"
  default     = []
}

## Loadbalancer

variable "elb_name" {
  type        = string
  description = "Name of the hello world application ELB"
  default     = ""
}

variable "app_port" {
  type        = string
  description = "Port the hello world application will be served on"
  default     = ""
}

variable "key_name" {
  type        = string
  description = "ssh key name"
  default     = ""
}

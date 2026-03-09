variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-north-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
  default     = "QuotesAppServer"
}

variable "key_name" {
  description = "Name of the existing SSH key pair for EC2 access"
  type        = string
  default     = "quotes-keypair"
}
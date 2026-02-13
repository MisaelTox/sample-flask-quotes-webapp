variable "aws_region" {
  default = "eu-north-1"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  description = "Name of the existing SSH key pair"
  default     = "mi-llave-quotes"
}

variable "project_name" {
  default = "QuotesAppServer"
}
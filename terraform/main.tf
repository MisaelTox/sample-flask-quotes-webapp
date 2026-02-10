terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

# Security Group (Firewall)
resource "aws_security_group" "quotes_sg" {
  name        = "quotes-app-sg"
  description = "Allow HTTP (5000) and SSH (22)"

  # Flask App
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH (RECOMENDADO: cámbialo por tu IP)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Latest Amazon Linux 2023
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

resource "aws_instance" "quotes_server" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"
  key_name      = "mi-llave-quotes"

  vpc_security_group_ids = [aws_security_group.quotes_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              set -e

              # Update
              sudo dnf update -y

              # Install Docker + Git
              sudo dnf install -y docker git

              sudo systemctl enable --now docker
              sudo usermod -aG docker ec2-user

              # Install Docker Compose (standalone binary)
              sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              sudo chmod +x /usr/local/bin/docker-compose
              sudo ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose

              # Clone repo
              mkdir -p /home/ec2-user/app
              cd /home/ec2-user/app
              git clone https://github.com/MisaelTox/sample-flask-quotes-webapp.git .

              # Go to terraform folder (where docker-compose.yaml exists)
              cd terraform

              # Start containers
              sudo /usr/local/bin/docker-compose up -d --build
              EOF

  tags = {
    Name = "QuotesAppServer"
  }
}

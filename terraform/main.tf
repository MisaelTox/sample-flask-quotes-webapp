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

# 1. Crear un Security Group (El Firewall)
resource "aws_security_group" "quotes_sg" {
  name        = "quotes-app-sg"
  description = "Permitir trafico HTTP y SSH"

  # Entrada: Puerto 5000 para la App
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ¡Ojo! Cualquiera puede entrar
  }

  # Entrada: Puerto 22 para SSH (Solo para ti)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Salida: Permitir que el servidor salga a internet (para bajar Docker)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Este bloque busca la AMI oficial más reciente de Amazon Linux 2023
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

resource "aws_instance" "quotes_server" {
  # Ahora usamos el ID que Terraform encontró dinámicamente
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"
  key_name      = "mi-llave-quotes"

  vpc_security_group_ids = [aws_security_group.quotes_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y docker git
              systemctl start docker
              systemctl enable docker
              usermod -a -G docker ec2-user
              
              mkdir -p /usr/local/lib/docker/cli-plugins/
              curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
              chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

              cd /home/ec2-user
              git clone https://github.com/MisaelTox/sample-flask-quotes-webapp.git
              cd sample-flask-quotes-webapp
              docker compose up -d
              EOF

  tags = {
    Name = "QuotesAppServer"
  }
}
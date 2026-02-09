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
              # 1. Instalar Docker, Git y Buildx (necesario para el build moderno)
              sudo dnf update -y
              sudo dnf install -y docker git docker-buildx
              sudo systemctl enable --now docker
              sudo usermod -aG docker ec2-user

              # 2. Instalar el binario de Docker Compose directamente (vía universal)
              sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              sudo chmod +x /usr/local/bin/docker-compose
              sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

              # 3. Preparar carpeta y clonar
              mkdir -p /home/ec2-user/app
              cd /home/ec2-user/app
              git clone https://github.com/MisaelTox/sample-flask-quotes-webapp.git .

              # 4. Crear el archivo docker-compose.yaml
              cat <<EOT > docker-compose.yaml
              services:
                db:
                  image: postgres:15
                  environment:
                    POSTGRES_USER: tox_admin
                    POSTGRES_PASSWORD: stpauli123
                    POSTGRES_DB: quotes_db
                web:
                  build: .
                  restart: always
                  ports:
                    - "5000:5000"
                  environment:
                    DATABASE_URL: postgresql://tox_admin:stpauli123@db:5432/quotes_db
                  depends_on:
                    - db
              EOT

              # 5. Permisos y Lanzamiento automático
              sudo chown -R ec2-user:ec2-user /home/ec2-user/app
              sudo /usr/local/bin/docker-compose up -d --build
              EOF

  tags = {
    Name = "QuotesAppServer"
  }
}
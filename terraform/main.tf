terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# 1. Security Group
resource "aws_security_group" "quotes_sg" {
  name        = "${var.project_name}-sg"
  description = "Allow HTTP (5000) and SSH (22)"

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-sg" }
}

# 2. Data Source para la AMI de Amazon Linux 2023
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

# 3. La Instancia EC2
resource "aws_instance" "quotes_server" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.quotes_sg.id]

user_data = <<-EOF
              #!/bin/bash
              # Redirect stdout and stderr to a log file for auditing and debugging
              exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
              
              echo "Starting deployment..."

              # Install base packages (Docker and Git)
              sudo dnf update -y
              sudo dnf install -y docker git

              # Manual installation of Docker Compose v2
              # This solves the 'unknown shorthand flag: -f' error in Amazon Linux 2023
              sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              sudo chmod +x /usr/local/bin/docker-compose
              sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

              # Start and enable Docker service
              sudo systemctl enable --now docker
              sudo usermod -aG docker ec2-user
              
              # Wait for the Docker engine to be fully active before proceeding
              while ! sudo docker info >/dev/null 2>&1; do echo "Waiting for Docker..."; sleep 2; done

              # Prepare the application directory and clone the repository
              mkdir -p /home/ec2-user/app
              cd /home/ec2-user/app
              git clone https://github.com/MisaelTox/sample-flask-quotes-webapp.git .

              # Create .env file with the required environment variables
              cat <<EOT > .env
              POSTGRES_USER=postgres
              POSTGRES_PASSWORD=changeme
              POSTGRES_DB=quotes
              FLASK_APP=app
              FLASK_DEBUG=False
              DATABASE_URL=postgresql://postgres:changeme@db:5432/quotes
              EOT

              # Launch the application using Docker Compose
              # Using the manual binary ensures full compatibility with the -f flag
              sudo /usr/local/bin/docker-compose -f terraform/docker-compose.yaml --project-directory . up -d --build

              echo "Deployment finished successfully."
              EOF

  tags = {
    Name = var.project_name
  }
}
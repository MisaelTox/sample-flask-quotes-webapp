# Flask Quotes Web Application — AWS Deployment (Terraform + Docker)

Automated deployment of a Dockerized **Flask** web application with a **PostgreSQL** database on **AWS EC2**, using **Terraform (IaC)** and **Docker Compose**.

## ⭐ Why this project matters

This project demonstrates an end-to-end, production-style deployment workflow:

- AWS infrastructure provisioning using **Terraform (IaC)**
- Automated EC2 configuration via **cloud-init / `user_data`**
- Containerized delivery with **Docker** and **Docker Compose**
- Multi-service orchestration (**Flask + PostgreSQL**) with persistent volumes
- Reproducible deployments and clean teardown with `terraform destroy`

It reflects the kind of automation used in real DevOps environments to ensure deployments are repeatable, scalable, and easy to maintain.

---

## 🔥 Project Highlights

- Automated EC2 provisioning with Terraform
- Automated Docker + Docker Compose installation via `user_data`
- Multi-container deployment (Flask + PostgreSQL)
- Persistent PostgreSQL data volumes
- Ready-to-run deployment in minutes
- Clean teardown with `terraform destroy`

---

## 🧱 Tech Stack

- **Cloud**: AWS (EC2, Security Groups)
- **IaC**: Terraform
- **Containers**: Docker, Docker Compose (v2)
- **Backend**: Flask (Python)
- **Database**: PostgreSQL
- **OS**: Amazon Linux 2023

---

---

## 🏗️ Architecture

    AWS (EC2)
    ┌──────────────────────────────────────┐
    │ EC2 Instance (Amazon Linux 2023)      │
    │                                      │
    │  ┌───────────────┐   ┌─────────────┐ │
    │  │ Flask App      │   │ PostgreSQL   │ │
    │  │ Port: 5000     │   │ Volume: yes  │ │
    │  └───────────────┘   └─────────────┘ │
    │                                      │
    │  Docker Compose (multi-container)     │
    └──────────────────────────────────────┘

---

## 🔍 What Terraform Provisions

- EC2 instance (Amazon Linux 2023)
- Security Group rules:
  - SSH access (port **22**)
  - Application traffic (port **5000**)
- Bootstrapping via `user_data`

---

## ⚙️ What is Automated via `user_data`

On first boot, the instance automatically:

- Installs Docker and Git
- Installs Docker Compose v2 (compatible with Compose `-f` flag)
- Clones the repository
- Generates a `.env` file with required variables
- Starts the full Docker Compose stack automatically

---

## 🛠️ Prerequisites

- Terraform installed  
  https://www.terraform.io/downloads.html

- AWS CLI configured with valid credentials

- An SSH Key Pair registered in your AWS region

---

## 🚀 Deployment (AWS)

### 1) Initialize Terraform

    terraform init

### 2) Review the Plan

    terraform plan

### 3) Apply Infrastructure

    terraform apply -auto-approve

---

## 📤 Terraform Outputs (Recommended)

After `terraform apply`, you should capture the public IP:

    terraform output

If your Terraform project exposes an output like `public_ip`, you can run:

    terraform output public_ip

---

## 🌍 Live Demo (App URL)

Wait ~5 minutes for Docker builds and database initialization, then open:

    http://<EC2_PUBLIC_IP>:5000

---

## 🔐 SSH Access

Connect to the instance using your key pair:

    ssh -i <YOUR_KEY.pem> ec2-user@<EC2_PUBLIC_IP>

Example:

    ssh -i ~/.ssh/my-aws-key.pem ec2-user@3.120.10.25

---

## 🐳 Verify Containers on EC2

Once inside the instance, you can check containers with:

    docker ps

Or view logs:

    docker compose logs -f

---

## 🧹 Cleanup

To avoid unnecessary AWS charges, destroy the infrastructure:

    terraform destroy -auto-approve

---

## 📌 Notes

This repository also contains the original Flask CRUD API project.  
The AWS deployment automation described above is an additional infrastructure layer built on top of it.

---

# Flask CRUD API (Local Development)

This is a simple Flask application that demonstrates CRUD (Create, Read, Update, Delete) operations using a PostgreSQL database.

The application allows you to manage quotes by inserting, updating, deleting, and retrieving quotes.

---

## Prerequisites

Before running the application locally, make sure you have:

- Python (version 3.6 or higher)
- pip package manager
- PostgreSQL (running database server)

> NOTE: Docker Compose reference for PostgreSQL setup:  
> https://github.com/khezen/compose-postgres/blob/master/docker-compose.yml

---

## Getting Started (Local)

### 1) Clone the repository

    git clone https://github.com/MisaelTox/sample-flask-quotes-webapp.git

### 2) Navigate into the project directory

    cd sample-flask-quotes-webapp

### 3) Install dependencies

    pip install -r requirements.txt

---

## Database Setup

### 1) Create a PostgreSQL database

Create a PostgreSQL database for the application.

### 2) Configure the database connection

Update the database connection URI in your `.env` file to match your PostgreSQL configuration.

The URI format should be:

    postgresql://username:password@hostname:port/database_name

Example `.env` content:

    FLASK_APP=app
    FLASK_DEBUG=False
    DATABASE_URL=postgresql://username:password@hostname:port/quotes_flask_curd

---

## Run the Application

Start the Flask server:

    flask run

---

## Access the Application

The Flask application will be running at:

    http://localhost:5000

---

## Usage

The application provides the following routes for managing quotes:

- `/` — Retrieves all quotes from the database
- `/random` — Retrieves a random motivational quote from an external API
- `/insert` — Inserts a new quote into the database
- `/update` — Updates an existing quote in the database
- `/delete/{id}/` — Deletes a quote from the database by ID

You can interact with these endpoints using tools such as Postman or cURL.

---

## Contributing

Contributions are welcome.

If you find issues or have suggestions for improvements, feel free to open an issue or submit a pull request.

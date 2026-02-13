# Flask Quotes Web Application - AWS Deployment

This project automates the deployment of a Dockerized Flask application with a PostgreSQL database on an **AWS EC2** instance using **Terraform**.

---

## 🏗️ Architecture
The infrastructure is defined as code (IaC) and includes:
* **EC2 Instance**: Amazon Linux 2023.
* **Security Group**: Configured to allow SSH (port 22) and App Traffic (port 5000).
* **Docker & Docker Compose**: Automated installation via `user_data` script.
* **Database**: PostgreSQL container with persistent volumes for data durability.



---

## 🛠️ Prerequisites
* [Terraform](https://www.terraform.io/downloads.html) installed.
* **AWS CLI** configured with proper credentials.
* A registered **SSH Key Pair** in your AWS region.

---

## 🚀 Deployment Steps

1. **Initialize Terraform:**
   ```bash
   terraform init
Review the Plan:

Bash
terraform plan
Apply Infrastructure:

Bash
terraform apply -auto-approve
Access the App:
Once the deployment finishes (wait ~5 minutes for Docker builds and database initialization), access the application at:
http://<EC2_PUBLIC_IP>:5000

🔍 Infrastructure Details
The deployment uses a custom user_data script to automate the following:

Package Management: Installs Docker and Git on Amazon Linux 2023.

Compatibility Fix: Installs the specific Docker Compose v2 binary to ensure full functionality of the -f flag.

Environment Setup: Clones the repository and injects environment variables via a generated .env file.

Container Orchestration: Launches the multi-container stack automatically on boot.

🧹 Cleanup
To avoid unnecessary AWS charges, destroy the infrastructure when finished:

Bash
terraform destroy -auto-approve

*(Original README starts below)*
---

# Flask CRUD API

This is a simple Flask application that demonstrates CRUD (Create, Read, Update, Delete) operations using a PostgreSQL database. The application allows you to manage quotes by inserting, updating, deleting, and retrieving quotes.

## Prerequisites

Before running the application, make sure you have the following installed:

- Python (version 3.6 or higher)
- pip package manager
- PostgreSQL (with a running database server)

| NOTE: Postgres installation on docker-compose reference: 
https://github.com/khezen/compose-postgres/blob/master/docker-compose.yml

## Getting Started

To get started with the application, follow these steps:

1. **Clone the repository:**

   ```bash
   $ git clone https://github.com/your-username/flask-crud-application.git

2. **Navigate to the project directory:**
    ```bash
    $ cd flask-crud-application
3. **Install the required dependencies:**
    ```bash
    $ pip install -r requirements.txt

4. **Setup database**
    - Create a PostgreSQL database for the application.
    - Update the database connection URI in .env file to match your PostgreSQL configuration. The URI should be of the format: 
    `postgresql://username:password@hostname:port/database_name`
    - Example `.env` content:
    ```bash
    FLASK_APP=app
    FLASK_DEBUG=False
    DATABASE_URL=postgresql://username:password@hostname:port/quotes_flask_curd
    ```
    
5. **Run Application:**
    ```bash
    flask run
6. **Access the Application**
    The Flask application will be running on http://localhost:5000. Open this URL in your web browser to access the application.

## Usage
The application provides the following routes for managing quotes:

- / - Retrieves all quotes from the database.
- /random - Retrieves a random motivational quote from an external API.
- /insert - Inserts a new quote into the database.
- /update - Updates an existing quote in the database.
- /delete/{id}/ - Deletes a quote from the database by ID.

To interact with the application, you can use tools like Postman or cURL to send HTTP requests to the respective routes.

## Contributing
Contributions are welcome! If you find any issues with the application or have suggestions for improvements, please feel free to submit an issue or a pull request.

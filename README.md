# Flask Quotes Web App - Cloud Deployment

A production-ready Flask application that serves random and stored quotes, deployed on **AWS EC2** using **Terraform** and **Docker Compose**.

## 🏗 Architecture
The project follows a microservices-like architecture:
* **Web Tier:** Flask application running on Python 3.9.
* **Database Tier:** PostgreSQL 15 for persistent storage.
* **Infrastructure:** AWS EC2 (t3.micro) provisioned via Terraform.
* **Orchestration:** Docker Compose manages the multi-container setup.

## 🚀 Deployment

### Prerequisites
* Terraform installed.
* AWS CLI configured with valid credentials.

### Infrastructure as Code
1. Navigate to the `terraform` directory.
2. Run `terraform init` to initialize the providers.
3. Run `terraform apply` to deploy the EC2 instance and Security Groups.

### Application Startup
The instance automatically installs Docker and clones this repository via `user_data`.
To manually restart the services:
\`\`\`bash
docker-compose up -d --build
\`\`\`

## 🛣 API Endpoints
* `GET /`: Returns all stored quotes in JSON format.
* `GET /random`: Fetches a random quote from an external API.
* `POST /insert`: Adds a new quote to the PostgreSQL database.

## 🛠 Tech Stack
* **Language:** Python (Flask)
* **Database:** PostgreSQL
* **DevOps:** Docker, Docker Compose, Terraform
* **Cloud:** AWS (EC2, VPC, Security Groups)
---
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

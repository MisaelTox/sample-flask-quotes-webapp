# Flask Quotes Webapp - AWS Automated Deployment

This project is a Flask-based web application that serves quotes, integrated with a PostgreSQL database. It is fully containerized using Docker and deployed automatically on AWS using Terraform.

## 🚀 Features

- **Automated Infrastructure**: Provisioned on AWS (Stockholm region `eu-north-1`) using Terraform.
- **Containerized Architecture**: Uses `docker-compose` to manage a Flask web server and a PostgreSQL database.
- **Zero-Touch Setup**: The instance automatically installs Docker, Git, and Buildx, clones the repository, and starts the services upon boot.

## 🛠️ Tech Stack

- **Backend**: Python (Flask)
- **Database**: PostgreSQL 15
- **Infrastructure**: Terraform, AWS (EC2, VPC, Security Groups)
- **Containerization**: Docker, Docker Compose

## 🔧 Quick Start (Terraform)

1. **Clone the repository**:
   ```bash
   git clone [https://github.com/MisaelTox/sample-flask-quotes-webapp.git](https://github.com/MisaelTox/sample-flask-quotes-webapp.git)
Initialize and Apply:

Bash
terraform init
terraform apply -auto-approve
Access the App: Once the deployment is complete, wait about 5 minutes for the Docker build to finish. Access the webapp at http://<EC2_PUBLIC_IP>:5000.

⚙️ Infrastructure Details
The main.tf file includes a user_data script that:

Updates and installs system dependencies.

Installs the latest Docker Compose binary and Buildx plugin.

Pulls the database image and builds the local Flask image.

Ensures the application stays up with a restart: always policy.


---
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

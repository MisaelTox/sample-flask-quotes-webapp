# Flask Quotes Web App — AWS Deployment

![CI/CD](https://github.com/MisaelTox/sample-flask-quotes-webapp/actions/workflows/ci-cd.yml/badge.svg?branch=main)
![AWS](https://img.shields.io/badge/AWS-EC2-orange?logo=amazon-aws)
![Terraform](https://img.shields.io/badge/IaC-Terraform-purple?logo=terraform)
![Docker](https://img.shields.io/badge/Container-Docker%20Compose-blue?logo=docker)
![Python](https://img.shields.io/badge/Backend-Flask-green?logo=python)

Production-ready deployment of a Dockerized **Flask + PostgreSQL** app on **AWS EC2**, using **Terraform** for infrastructure provisioning and **Docker Compose** for container orchestration.

> **Deployment Status:** Offline — destroy via `terraform destroy` to avoid charges. All IaC configs in `/terraform`.

---

## 🏗️ Architecture
```
AWS (EC2 - Amazon Linux 2023)
┌──────────────────────────────────────┐
│  ┌───────────────┐   ┌─────────────┐ │
│  │ Flask App      │   │ PostgreSQL   │ │
│  │ Port: 5000     │   │ Volume: yes  │ │
│  └───────────────┘   └─────────────┘ │
│  Docker Compose (multi-container)     │
└──────────────────────────────────────┘
```

| Component | Technology |
|-----------|-----------|
| Infrastructure | AWS EC2 + Security Groups |
| IaC | Terraform |
| Orchestration | Docker Compose v2 |
| Backend | Flask (Python) |
| Database | PostgreSQL (persistent volume) |
| CI/CD | GitHub Actions |

---

## 🔄 CI/CD Pipeline
```
Push to main
      ↓
✅ App CI (parallel)          ✅ Terraform CI (parallel)
   → pip install                 → terraform fmt
   → docker build                → terraform validate
      ↓                               ↓
      └──────────── both pass ────────┘
                      ↓
           ⏸️ Manual approval gate
                      ↓
            🚀 terraform apply → provisions EC2
```

AWS credentials stored as **GitHub Secrets** — never hardcoded.

---

## 🚀 Deployment
```bash
cd terraform
terraform init
terraform apply -auto-approve
```

The `user_data` script automatically installs Docker, clones the repo, and starts all containers (~5 min). Access at `http://<EC2_PUBLIC_IP>:5000`.

---

## 🐍 Local Development
```bash
pip install -r requirements.txt
flask run
```

Requires PostgreSQL running locally. Configure `.env` based on `.env.example`.

---

## 📡 API Routes

| Route | Method | Description |
|-------|--------|-------------|
| `/` | GET | All quotes |
| `/random` | GET | Random quote from external API |
| `/insert` | POST | Add new quote |
| `/update` | PUT | Update existing quote |
| `/delete/{id}/` | DELETE | Delete quote by ID |

---

## 🧹 Cleanup
```bash
terraform destroy -auto-approve
```

---

## 📝 Lessons Learned

- **CI/CD with GitHub Actions** — parallel Flask + Terraform validation with manual approval gate before AWS provisioning
- **user_data automation** — fully automated EC2 bootstrap: Docker install, repo clone, and Compose stack start on first boot
- **Docker Compose v2** — resolved compatibility issues between Amazon Linux 2023 and modern Compose plugin syntax
- **Persistent volumes** — configured PostgreSQL data volume to survive container restarts

---

*Fork of [jaykantrprj/sample-flask-quotes-webapp](https://github.com/jaykantrprj/sample-flask-quotes-webapp). Cloud infrastructure and CI/CD pipeline added by MisaelTox.*
# DevOps Project — SimpleTimeService

---

## 1. Introduction

This project demonstrates a complete DevOps workflow where I designed, built, and deployed a containerized microservice using Infrastructure as Code and CI/CD pipelines.

The application is a simple API that returns the current timestamp and client IP address in JSON format.

 “The goal was to implement an end-to-end automated deployment pipeline.”

## 2. Prerequisites & Setup (Before Deployment)

Before running this project, some initial setup is required.

Tools Required:
Terraform,
Docker,
Git

“These tools are required to build, deploy, and manage the infrastructure.”

* Docker Setup
* Create DockerHub account
* Ensure image repository is public

"ECS needs public access to pull the Docker image.”

GitHub Actions Setup (IMPORTANT)
1. Configure GitHub Secrets

Go to:
GitHub → Repository → Settings → Secrets

Add:

* DOCKER_USERNAME
* DOCKER_PASSWORD
* OIDC (IAM Role ARN)
* region

“Secrets are used to securely authenticate without hardcoding credentials.”

 2. AWS IAM Role for OIDC
Create IAM Role with:
Trust: GitHub OIDC provider
Permissions: ECS, ECR (optional), S3, etc.

“This enables secure, password-less authentication from GitHub to AWS.”

3. Enable GitHub Environment (Optional)
Create environment: dev
Add approval rules (optional)

“This adds an approval gate before deployment.”
---

## 3. Application Layer

I built a lightweight microservice using **FastAPI (Python)**.

* Endpoint: `/`
* Output:

  * Current timestamp
  * Client IP

The application is designed to be minimal, stateless, and easy to containerize.

---

## 4. Containerization

The application is packaged using Docker.

Key points:

* Uses a lightweight base image (`python:slim`)
* Runs as a **non-root user** for security
* Exposes port `8080`

The image is pushed to DockerHub and used during deployment.

---

## 5. Infrastructure Design (Terraform)

I provisioned infrastructure using **Terraform with a modular structure**.

### Components created:

* VPC with public and private subnets
* Internet Gateway and NAT Gateway
* ECS Fargate Cluster
* Application Load Balancer (ALB)
* Route53 (DNS)
* ACM (SSL certificate)

“Infrastructure is fully defined using Terraform for repeatability.”
---

## 6. Security Architecture

Security was a key design focus:

* ECS runs in **private subnets only**
* No direct internet access to containers
* ALB acts as the only entry point
* Security Groups allow traffic:

  * Internet → ALB
  * ALB → ECS (only)

“This ensures the application is not directly exposed to the internet.”

---

## 7. Terraform State Management

Terraform state is stored remotely in **S3 backend**.

* S3 bucket stores the state file
* Locking mechanism prevents concurrent updates

This ensures:

* Safe collaboration
* Consistent infrastructure state
* No accidental overwrites

---

## 8. Deployment Approaches

The project supports two deployment methods:

---

# 8A. Manual Deployment

This is used for:

* Initial setup
* Debugging
* Understanding flow

### Steps:

1. Build Docker image
2. Push to DockerHub
3. Run Terraform apply
4. Access application via ALB

### Updating application manually:

* Build and push new image
* Trigger ECS deployment using:

```
aws ecs update-service --force-new-deployment
```

---

# 8B. Automated Deployment (CI/CD)

This is the **primary deployment method**.

---

## 🔹 CI Pipeline (Build & Push)

### Trigger:

* Runs on code push

### Steps:

1. Build Docker image
2. Tag image as `latest`
3. Push image to DockerHub

---

## 🔹 CD Pipeline (Deploy)

### Trigger:

* Automatically triggered after CI completes

### Steps:

1. Authenticate to AWS using OIDC
2. Trigger ECS deployment using:

```
aws ecs update-service --force-new-deployment
```

---

## What happens during deployment?

* ECS pulls latest image
* Starts new containers
* Gradually replaces old containers
* Ensures no downtime

---

## 9. Rolling Deployment Strategy

The ECS service is configured with:

* Minimum healthy: 50%
* Maximum capacity: 200%
* Forced deployment enabled

This ensures:

* Zero downtime
* High availability
* Smooth upgrades

---

## 10. End-to-End Flow

```
User → Route53 → ALB → ECS → Container

 “Traffic flows through ALB into private ECS tasks.”
```

---

## 11. Complete Automation Flow

```
Developer pushes code
   ↓
CI builds Docker image
   ↓
Image pushed to DockerHub
   ↓
CD triggers ECS deployment
   ↓
Rolling update happens
   ↓
Application updated with zero downtime
```

---

## 12.  Key Design Decisions

* Terraform for reproducible infrastructure
* ECS Fargate to avoid server management
* Private subnets for security
* ALB for controlled access
* CI/CD separation for faster deployments
* S3 backend for reliable state management with locking enabled

---

## 13.  Final Outcome

This project delivers:

* Fully automated infrastructure
* Secure cloud architecture
* Zero-downtime deployments
* Clear separation of infrastructure and application lifecycle

---

## 14.  Cleanup

To avoid AWS charges:

```
terraform destroy -var-file="test.tfvars"
```

---

## Conclusion

This implementation demonstrates a production-style DevOps workflow with automation, scalability, and security best practices.

---

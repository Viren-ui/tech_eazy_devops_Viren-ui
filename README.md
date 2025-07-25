# 🚀 Techeazy DevOps Assignment 3 - Fully Automated EC2 App Deployment

This project automates the complete deployment of a Spring Boot application on an AWS EC2 instance using **Terraform** and **GitHub Actions**. It ensures logs are stored in **S3**, enforces proper IAM roles, and the deployment is triggered seamlessly on every push or via the GitHub Actions UI — no manual steps needed!

---

## ✅ Features

- 🌐 **EC2 Instance** with Java 21 + Spring Boot App exposed on **port 80**
- 📦 **Terraform** code handles all infrastructure provisioning
- ⚙️ **GitHub Actions**: CI/CD pipeline auto-deploys on push or manual trigger
- 🔐 **IAM Roles**:
  - Read-only role for log readers
  - Write-only role for the EC2 app instance
- 📁 **Logs automatically uploaded to S3**:
  - `/app/logs/app.log`
  - `/system/cloud-init.log`
- 🗑️ **S3 Lifecycle Rule**: Logs auto-delete after 7 days
- 🛢️ **Persistent H2 Database** (file-based)

---

## 📦 Prerequisites

Before deployment, ensure:

1. Go to your GitHub repo → **Settings** → **Secrets and Variables** → **Actions**
2. Add these secrets:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `INSTANCE_KEY` — content of your `.pem` EC2 SSH key

3. These credentials must have permissions for EC2, S3, and IAM resource management.

---

## ⚙️ Application Configuration

The app uses a **file-based H2 database** located at `./data/parceldb`.

Ensure the following in `application.properties`:

```properties
spring.application.name=techeazy-devops
server.port=8080
stage.name=${STAGE:dev}

spring.datasource.url=jdbc:h2:file:./data/parceldb;DB_CLOSE_ON_EXIT=FALSE;AUTO_SERVER=TRUE;IFEXISTS=TRUE
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=

spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
spring.jpa.hibernate.ddl-auto=create

spring.h2.console.enabled=true
spring.h2.console.path=/h2-console
spring.h2.console.settings.web-allow-others=true
```

---

## 🚀 How to Deploy

You have **two options**:

### Option 1: Auto Deploy on Push

- Push any commit to your branch (`feature/devops-assignment-3`) to trigger deployment.

### Option 2: Manual Trigger

1. Go to the **Actions** tab on GitHub
2. Select **“EC2 Deploy via terraform”**
3. Click **“Run workflow”**
4. Watch the logs — Terraform will:
   - Provision EC2 and S3
   - Output the **public IP** (see `Terraform Apply` step)
   - Build and launch the app

---

## 🌐 Access the App

After deployment:

1. Open **GitHub → Actions**
2. Click on the latest successful **Deploy workflow run**
3. Scroll to the **Terraform Apply** step logs
4. Look for output like:

   ```
   Outputs:

   ec2_public_ip = "YOUR_PUBLIC_IP"
   ```

5. Visit [http://YOUR_PUBLIC_IP](http://YOUR_PUBLIC_IP) in your browser — you should see the app running! 🎉

---


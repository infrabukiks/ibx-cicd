

## ✅ 1. Learning Objectives

* Understand how to build and containerize a modern web application using best practices.
* Learn to set up an end-to-end CI/CD pipeline using **GitHub Actions** and **ArgoCD** for GitOps-driven deployments.
* Provision your own infrastructure on **a public cloud (e.g., AWS/GCP)** using **Terraform** and **Kubernetes (K3s/EKS/GKE)**.
* Implement **Canary Deployments** using **Argo Rollouts** or **Flagger**.
* Simulate real-world production issues (e.g., config errors, merge conflicts, broken deployments) and resolve them with **incident response runbooks**.
* Follow **12-Factor App** methodology and **DevSecOps** practices for observability, secrets management, and reliability.

---

## ✅ 2. Case Description

> Create a full-stack DevOps pipeline that builds a simple web application (e.g., Python FastAPI or Node.js), containerizes it with Docker, and deploys it to a self-managed Kubernetes cluster using GitOps practices. The deployment should support Canary strategy, auto-scaling, and failure recovery.

This project will serve as a full-cycle DevOps portfolio piece—from provisioning infra, building pipelines, deploying workloads, simulating ops failures, and documenting incident resolution steps.

---

## ✅ 3. Assumptions

* No pre-existing infra or clusters will be provided—you will:

  * Provision your own cloud-based infra using Terraform
  * Set up your own Kubernetes cluster (EKS/GKE/K3s)
* Source code will be stored on GitHub or GitLab
* You are expected to use modern DevOps tools, such as:

  * **Terraform, Docker, GitHub Actions, ArgoCD, Helm, Prometheus/Grafana, Loki**
* You will manage your own secrets using **Sealed Secrets** or **Vault**
* Web app color or feature should visibly change in each deployment (for validation)

---

## ✅ 4. Limitations

* No managed CI/CD platform like TeamCity—CI/CD must be built with open-source/hosted tools (GitHub Actions, ArgoCD)
* No prebuilt Docker images or helm charts; you must create them yourself
* Cloud cost must be kept minimal (free tier services or local K3s if needed)
* You must handle RBAC, Ingress, Service Mesh setup (if used)
* Realistic latency and failure conditions will be simulated to validate observability

---

## ✅ 5. Solution Must-Haves

### 🔁 Version Control

* GitHub repository with:

  * `main`, `feature/*`, and `hotfix/*` branches
  * Branch protection rules for `main`
  * Required status checks (e.g., tests, lint, build)

### 🏗 Infrastructure

* Infrastructure-as-Code (IaC) using **Terraform**

  * Provision cloud compute/network resources
  * Setup Kubernetes (K3s/EKS/GKE)
  * Bootstrap ArgoCD for GitOps

### ⚙️ CI/CD

* CI: **GitHub Actions**

  * Run tests, linters, build Docker image
  * Push image to **Docker Hub/GitHub Container Registry**
* CD: **ArgoCD** + GitOps repo

  * Sync changes from a separate deployment repo
  * Use **Helm/Kustomize** for manifests
  * Include Canary rollout config

### 🧪 Canary Deployment

* Use **Argo Rollouts** or **Flagger**

  * Show visual rollout stages (with Grafana or UI)
  * Background color change validates each stage

### 🔒 Security & Secrets

* Use **Sealed Secrets** or **HashiCorp Vault** for sensitive data
* RBAC and least privilege for GitHub Actions, ArgoCD, etc.

### 📉 Observability

* Setup **Prometheus, Grafana, Loki** stack

  * Visualize CPU/mem/network metrics
  * Track logs and alerts

### ⚠️ Ops Simulation

* Intentionally:

  * Introduce Git merge conflicts
  * Break config files
  * Push a broken image
* Write **runbooks** on how to resolve these issues using logs, rollback, etc.

---

📁 Folder Structure

```
ibx-cicd/                             # Root project folder
├── .github/                         # GitHub Actions workflows
│   └── workflows/
│       └── ci.yml                   # CI pipeline: test, build, push image
├── apps/
│   └── web-app/
│       ├── Dockerfile               # Dockerfile for the web app
│       ├── app/                     # App source code
│       ├── requirements.txt         # Python/Node/etc. dependencies
│       └── README.md                # App-specific info
├── charts/
│   └── web-app/                     # Helm chart for K8s deployment
│       ├── templates/
│       └── values.yaml
├── infra/
│   ├── terraform/
│   │   ├── main.tf                  # Terraform config for infra
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── k8s-bootstrap/
│       ├── argocd-install.yaml      # ArgoCD manifests
│       └── namespaces.yaml
├── k8s/
│   └── overlays/
│       └── prod/
│           ├── kustomization.yaml
│           └── deployment.yaml
├── runbooks/
│   ├── merge-conflict.md
│   ├── ci-failure.md
│   ├── config-break.md
│   └── canary-observation.md
├── .gitignore
├── README.md
└── LICENSE
```

Perfect. We'll now rewrite **Step-by-Step: Zero to Prod** into a **detailed, beginner-friendly guide**—each step will be broken down with:

* 🔧 clear commands
* 📦 file samples
* 🧠 explanations
* ✅ checkpoints

---

># Step by Step Guide

# ✅ Step 0: Initialize the Project (Local + GitHub)

## 🧠 Goal:

Set up a GitHub repository and project folder structure to hold everything (app code, CI/CD config, infra, etc.)

---

## 🔹 0.1. Create Your GitHub Repository

1. Open your terminal.
2. Run this command to create the GitHub repo:

```bash
gh repo create ibx-cicd --public --clone
```

This will:

* Create a **new repo named `ibx-cicd`** in your GitHub account.
* **Clone it locally** so you can start adding files.

If you don’t have `gh` installed:

```bash
brew install gh  # macOS
sudo apt install gh  # Ubuntu/Debian
```

---

## 🔹 0.2. Set Up Local Project Folder Structure

Run this in the root of your new repo:

```bash
mkdir -p .github/workflows
mkdir -p apps/web-app/app
mkdir -p charts/web-app/templates
mkdir -p infra/terraform
mkdir -p runbooks
touch README.md .gitignore
```

Here’s what these folders are for:

| Folder/File          | Purpose                            |
| -------------------- | ---------------------------------- |
| `.github/workflows/` | CI pipelines via GitHub Actions    |
| `apps/web-app/`      | Source code and Dockerfile         |
| `charts/web-app/`    | Helm chart for Kubernetes          |
| `infra/terraform/`   | Infra-as-code for cloud setup      |
| `runbooks/`          | Docs on how to fix failures        |
| `README.md`          | Overview of your project           |
| `.gitignore`         | Prevent tracking of unwanted files |

---

## 🔹 0.3. Create `.gitignore` File

```bash
cat <<EOF > .gitignore
__pycache__/
*.pyc
*.db
*.env
*.log
.env
node_modules/
.DS_Store
*.tfstate
*.tfstate.backup
EOF
```

This prevents unnecessary files from being tracked by Git.

---

## 🔹 0.4. First Commit and Push

```bash
git add .
git commit -m "📦 Initialized project structure"
git push -u origin main
```

✅ **Checkpoint:**
Go to your GitHub repo (`https://github.com/your-username/ibx-cicd`)
→ You should see your folders and files.

---

# ✅ Step 1: Build the Web App (Beginner-Friendly)

## 🧠 Goal:

Create a simple Python-based web app using **FastAPI** that changes its background color based on an environment variable (e.g., `BG_COLOR`).

We’ll:

* Write the code
* Create a `Dockerfile`
* Run it locally to test

---

## 🔹 1.1. Create the App Directory

In your terminal:

```bash
cd apps/web-app
mkdir app
cd app
```

---

## 🔹 1.2. Create the FastAPI App

Create a file named `main.py`:

```bash
touch main.py
```

Paste the following code:

```python
# apps/web-app/app/main.py

from fastapi import FastAPI
from fastapi.responses import HTMLResponse
import os

app = FastAPI()

@app.get("/", response_class=HTMLResponse)
def home():
    color = os.getenv("BG_COLOR", "white")
    html = f"""
    <html>
        <body style='background-color:{color};'>
            <h1 style='color:black;text-align:center;margin-top:200px;'>
                CI/CD Demo - Background Color: {color}
            </h1>
        </body>
    </html>
    """
    return html
```

🧠 **Explanation:**

* The background color is read from the environment variable `BG_COLOR`.
* We return an HTML page with the background set to this color.

---

## 🔹 1.3. Create `requirements.txt`

```bash
cd ..
touch requirements.txt
```

Add this content:

```
fastapi
uvicorn
```

---

## 🔹 1.4. Create a `Dockerfile`

At `apps/web-app/Dockerfile`:

```Dockerfile
# Use a lightweight Python image
FROM python:3.11-slim

# Set the working directory
WORKDIR /app

# Copy code and install dependencies
COPY app/ ./app/
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Expose the app on port 80
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]
```

🧠 **Why it works:**

* This builds a container with FastAPI ready to run the app.
* The `CMD` tells Docker how to start the server.

---

## 🔹 1.5. Test the App Locally

### 🛠 Build the Image:

```bash
docker build -t web-app:dev .
```

### ▶️ Run the App:

```bash
docker run -p 8080:80 -e BG_COLOR=green web-app:dev
```

Open your browser at [http://localhost:8080](http://localhost:8080)
✅ You should see a page with a green background.

Try changing the color:

```bash
docker run -p 8080:80 -e BG_COLOR=orange web-app:dev
```

---

## 🔄 1.6. Version Control the App

```bash
cd ../../../  # Go back to repo root
git add apps/web-app
git commit -m "🎨 Added simple FastAPI app with BG_COLOR env support"
git push
```

✅ **Checkpoint:**

* You now have a containerized app ready for CI/CD.
* The app is configurable via an environment variable.

---

Absolutely! Here's your **updated and complete Step 2 guide**, reflecting everything we've done — including:

* ✅ Using **Free Tier (`t2.micro`)**
* ✅ Adding a **Security Group** to allow SSH only from your IP (`143.44.165.146`)
* ✅ Using **Ubuntu 24.04 LTS**
* ✅ Using your **actual `.pem` key path**
* ✅ Ensuring `k3s` is installed via Terraform provisioner

---

# ✅ Step 2: Provision Infrastructure with Terraform (Updated)

## 🧠 Goal:

Provision your own infrastructure **from scratch** using **Terraform**, so we can:

* Host a Kubernetes cluster (**K3s** for now)
* Install ArgoCD later for GitOps

We’re using a **lightweight K3s setup** on an **EC2 Free Tier–eligible instance**.

---

## 🔹 2.1. Folder Setup

```bash
cd ibx-cicd
mkdir -p infra/terraform
cd infra/terraform
touch main.tf variables.tf outputs.tf
```

---

## 🔹 2.2. Configure AWS Credentials

If you haven’t already:

```bash
aws configure
```

Input:

* AWS Access Key
* AWS Secret Access Key
* Region: `ap-southeast-1` (or your preferred)

---

## 🔹 2.3. `variables.tf`

```hcl
# infra/terraform/variables.tf

variable "aws_region" {
  default = "ap-southeast-1"
}

variable "instance_type" {
  default = "t2.micro" # ✅ Free Tier eligible
}

variable "key_name" {
  description = "Name of your existing EC2 key pair"
  type        = string
}
```

---

## 🔹 2.4. `main.tf`

```hcl
# infra/terraform/main.tf

provider "aws" {
  region = var.aws_region
}

# 🔐 Allow SSH only from your current public IP
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH from your IP"

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["143.44.165.146/32"] # ✅ Your public IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 🖥️ EC2 instance with K3s
resource "aws_instance" "k3s_node" {
  ami                         = "ami-02c7683e4ca3ebf58" # ✅ Ubuntu 24.04 LTS for ap-southeast-1
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  tags = {
    Name = "k3s-master"
  }

  provisioner "remote-exec" {
    inline = [
      "curl -sfL https://get.k3s.io | sh -"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("/Users/john.abucay/infrabukiks/aws-cred/infrabukiks.pem")
      host        = self.public_ip
    }
  }
}
```
> Note: User `curl ifconfig.me` to get the local public IP

---

## 🔹 2.5. `outputs.tf`

```hcl
# infra/terraform/outputs.tf

output "instance_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.k3s_node.public_ip
}
```

---

## 🔹 2.6. Initialize Terraform

```bash
terraform init
```

✅ Output:

```
Terraform has been successfully initialized!
```

---

## 🔹 2.7. Apply the Infrastructure

```bash
terraform apply
```

When prompted:

```
var.key_name
  Enter a value: infrabukiks
```

✅ Then type `yes` to approve.

---

## 🔹 2.8. SSH into the Server

Get the public IP from the output, then:

```bash
ssh -i /Users/john.abucay/infrabukiks/aws-cred/infrabukiks.pem ubuntu@<instance_public_ip>
```

✅ You’ll be inside your Ubuntu 24.04 EC2 server.

---

## 🔹 2.9. Verify K3s is Running

Run:

```bash
sudo kubectl get nodes
```

✅ Output should show:

```
NAME               STATUS   ROLES                  AGE   VERSION
ip-xxx-xxx         Ready    control-plane,master   1m    v1.32.5+k3s1
```

---

## 🔄 2.10. Version Control Your Work

```bash
cd ~/your-path-to/ibx-cicd
git add infra/terraform
git commit -m "🚀 Provisioned K3s-ready EC2 via Terraform (Free Tier)"
git push
```

---

## ✅ Checkpoint Complete

✅ EC2 is live
✅ K3s is installed
✅ SSH access is secured

---

# ✅ Step 3: Install Kubernetes Tools (ArgoCD)

## 🧠 Goal:

Install **ArgoCD** into your **K3s cluster** so you can manage app deployments using **GitOps** — just push code to Git and ArgoCD takes care of the rest!

---

## 🛠 Prerequisites

Ensure the following:

* ✅ You're SSH’d into your EC2 instance (`ubuntu@...`)
* ✅ You've verified K3s is running:

  ```bash
  sudo kubectl get nodes
  ```

---

## 🔹 3.1. Create the `argocd` Namespace

Inside EC2:

```bash
sudo kubectl create namespace argocd
```

---

## 🔹 3.2. Install ArgoCD Core

Install the official manifest:

```bash
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

✅ This installs:

* `argocd-server`
* `argocd-repo-server`
* `argocd-application-controller`
* `argocd-dex-server`

---

## 🔹 3.3. Wait for All ArgoCD Pods to Start

```bash
sudo kubectl get pods -n argocd -w
```

Wait until all pods are in `Running` status. Press `Ctrl+C` to exit.

---

## 🔹 3.4. Set Up Local Access to the ArgoCD Dashboard

Since ArgoCD is inside your EC2 VM, we’ll use **SSH port forwarding** so you can view the dashboard from your **local browser**.

### 🧩 Step 1: Start SSH tunnel **from your laptop**

```bash
ssh -i /Users/john.abucay/infrabukiks/aws-cred/infrabukiks.pem -L 8080:localhost:8080 ubuntu@<EC2_PUBLIC_IP>
```

Keep this terminal open — it forwards EC2 port `8080` to your `localhost:8080`.

### 🧩 Step 2: Inside EC2, run:

```bash
sudo kubectl port-forward svc/argocd-server -n argocd 8080:443
```

### 🔗 Step 3: Visit the ArgoCD UI in your browser

👉 Go to: [https://localhost:8080](https://localhost:8080)

✅ You’ll see a TLS warning (self-signed cert). Proceed anyway.

---

## 🔹 3.5. Get ArgoCD Admin Password

Inside EC2:

```bash
sudo kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
```

📋 Save this password.
**Username:** `admin`
**Password:** (the output above)

---

## 🔹 3.6. (Optional) Use ArgoCD CLI

Install CLI locally (optional but helpful):

```bash
brew install argocd  # For macOS
```

Then login:

```bash
argocd login localhost:8080 --username admin --password <your-password> --insecure
```

---

## 🔄 3.7. (Optional) Version Control ArgoCD Setup

To track ArgoCD setup in your repo:

```bash
mkdir -p infra/k8s-bootstrap
cd infra/k8s-bootstrap
curl -O https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Then:

```bash
git add infra/k8s-bootstrap
git commit -m "🚀 Installed ArgoCD in K3s cluster"
git push
```

---

## ✅ Checkpoint

✅ You now have a fully working **ArgoCD GitOps controller** running on your K3s cluster.

You can now:

* Deploy apps by pushing YAML to Git
* Manage environments visually
* Automate sync and rollback
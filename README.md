# 🚀 ibx-cicd: Zero to Production DevOps Case Study

This project demonstrates a complete DevOps pipeline built **from scratch to production**, using modern tools and GitOps practices. It's designed for beginners who want to understand CI/CD, Kubernetes, observability, and real-world troubleshooting in a cloud-native environment.

---

## 🧠 Learning Objectives

- Build a modern web app and containerize it with Docker
- Provision infrastructure using Terraform (K3s on EC2)
- Set up CI/CD using GitHub Actions and ArgoCD
- Implement GitOps with automated syncing and rollback
- Perform Canary deployments using Argo Rollouts
- Add observability with Prometheus, Grafana, and Loki
- Simulate production failures and respond with runbooks

---

## 🧰 Tech Stack

| Area             | Tools Used                                   |
|------------------|----------------------------------------------|
| Infrastructure   | Terraform, AWS EC2, K3s                      |
| CI/CD            | GitHub Actions + ArgoCD (GitOps)            |
| Containers       | Docker, GHCR                                 |
| K8s Deployments  | Kustomize, Argo Rollouts                     |
| Observability    | Prometheus, Grafana, Loki                    |
| Secrets Mgmt     | Sealed Secrets (future)                      |
| Logging          | Grafana Loki                                 |

---

## 📦 Project Structure

```

ibx-cicd/
├── .github/workflows/          # GitHub Actions CI
├── apps/web-app/               # FastAPI App & Dockerfile
├── charts/web-app/             # Helm chart (optional)
├── infra/
│   ├── terraform/              # Terraform EC2 provisioning
│   └── k8s-bootstrap/          # ArgoCD App manifests
├── runbooks/                   # Incident response guides
└── README.md

````

---

## 🛠 Setup: Step-by-Step Guide

Each step is designed for beginners. Just follow in order:

| Step | Description |
|------|-------------|
| ✅ Step 0 | [Initialize Project Structure](#) |
| ✅ Step 1 | [Build the Web App (FastAPI)](#) |
| ✅ Step 2 | [Provision K3s on EC2 via Terraform](#) |
| ✅ Step 3 | [Install ArgoCD on Kubernetes](#) |
| ✅ Step 4 | [Set up CI with GitHub Actions](#) |
| ✅ Step 5 | [Deploy with ArgoCD + GitOps](#) |
| ✅ Step 6 | [Canary Deployments with Argo Rollouts](#) |
| ✅ Step 7 | [Observability with Prometheus, Grafana, Loki](#) |
| ✅ Step 8 | [Failure Simulations + Runbooks](#) |

---

## 🧪 GitOps Deployment Overview

- All deployments are driven from a separate GitOps repo: [`ibx-cicd-deploy`](https://github.com/your-org/ibx-cicd-deploy)
- ArgoCD watches this repo and applies any changes automatically
- Canary rollouts prevent bad versions from going fully live

---

## 📊 Observability

- Prometheus tracks app health (CPU, memory, pod state)
- Grafana provides dashboards and visual alerts
- Loki centralizes logs — search by pod, container, etc.

---

## 🧯 Runbooks

| File | Scenario |
|------|----------|
| [`ci-failure.md`](runbooks/ci-failure.md) | CI fails due to broken code |
| [`merge-conflict.md`](runbooks/merge-conflict.md) | Git conflict during PR merge |
| [`config-break.md`](runbooks/config-break.md) | Deployment fails due to YAML error or crash |
| [`canary-observation.md`](runbooks/canary-observation.md) | Rollout pauses due to failed canary |

Each runbook contains:
- 📌 Symptoms
- 🔍 Diagnosis steps
- 🛠 Resolution process

---

## 🌐 Accessing Your App

Once deployed:
```bash
kubectl get svc web-app
````

Look for `EXTERNAL-IP` and visit `http://<external-ip>`

---

## 🚀 Deploy New Version

1. Update your app (e.g., change `BG_COLOR`)
2. Commit and push to `main`
3. GitHub Actions builds and pushes image
4. ArgoCD picks up changes from GitOps repo
5. Argo Rollouts gradually releases new version

---

## 🔐 Secrets & Security (Planned)

To be implemented:

* Sealed Secrets for sensitive K8s values
* RBAC for GitHub workflows & ArgoCD

---

## 📋 Requirements

* AWS Account (with EC2 and Key Pair)
* GitHub CLI (`gh`)
* Terraform CLI
* Docker
* kubectl + Helm
* Optional: ArgoCD & Rollouts CLI

---

## 📘 License

MIT License © 2025 John Carl Abucay


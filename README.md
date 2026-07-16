## ☁️ Platform Infrastructure

<div align="center">

![Terraform](https://img.shields.io/badge/Terraform-Infrastructure_as_Code-623CE4?style=for-the-badge&logo=terraform)
![Google Cloud](https://img.shields.io/badge/Google_Cloud-GCP-4285F4?style=for-the-badge&logo=googlecloud)
![Google Kubernetes Engine](https://img.shields.io/badge/Google_Kubernetes_Engine-GKE-326CE5?style=for-the-badge&logo=kubernetes)
![Infrastructure](https://img.shields.io/badge/Infrastructure-Terraform-7B42BC?style=for-the-badge)
![IaC](https://img.shields.io/badge/Infrastructure_as_Code-IaC-0F9D58?style=for-the-badge)

**Terraform-based Infrastructure as Code (IaC) for provisioning a production-inspired Kubernetes platform on Google Cloud Platform.**

This repository provisions the complete cloud infrastructure required to run the platform, including networking, Google Kubernetes Engine (GKE), IAM, Artifact Registry, Cloud SQL, Cloud Storage, and shared Kubernetes platform services. It provides a modular, reusable, and production-oriented infrastructure foundation for GitOps-based deployments.

</div>

---
## Overview

This repository provisions and manages the foundational cloud infrastructure for a production-inspired Kubernetes platform on **Google Cloud Platform (GCP)** using **Terraform**. By adopting Infrastructure as Code (IaC), it enables consistent, repeatable, and automated infrastructure provisioning while promoting modularity, maintainability, and operational reliability.

The infrastructure is implemented as a collection of reusable Terraform modules that provision the core cloud resources required to operate the platform, including networking, Google Kubernetes Engine (GKE), Identity and Access Management (IAM), Artifact Registry, Cloud Storage, Cloud SQL for PostgreSQL, and other shared infrastructure services. In addition, the repository automates the deployment of essential Kubernetes platform components, establishing a secure and scalable foundation for cloud-native workloads.

This repository is responsible exclusively for infrastructure provisioning and platform foundation. Application deployment, configuration management, and continuous delivery are managed separately through a GitOps workflow with Argo CD, ensuring a clear separation of concerns between infrastructure lifecycle management and application operations.

---
## 🏗️  Architecture

The following architecture illustrates the complete platform deployment on GCP.

<p align="left">
  <img src="docs/images/arch.png" width="550" alt="Terraform">
</p>

---
## 🚀 Infrastructure Capabilities

| Capability | Description |
|------------|-------------|
| **Infrastructure as Code** | Provisions cloud infrastructure using reusable and modular Terraform modules. |
| **Cloud Foundation** | Deploys foundational resources on Google Cloud Platform (GCP). |
| **Networking** | Configures a custom VPC, private subnet, Cloud Router, Cloud NAT, Private Google Access, and firewall rules. |
| **Kubernetes Platform** | Provisions a private, VPC-native Google Kubernetes Engine (GKE) cluster. |
| **Node Architecture** | Creates dedicated system, application, and data node pools with workload isolation using labels and taints. |
| **Identity & Access Management** | Implements IAM, service accounts, and Workload Identity Federation following least-privilege principles. |
| **Container Registry** | Provisions Artifact Registry repositories for container image storage. |
| **Terraform State** | Configures a Google Cloud Storage backend for remote Terraform state management. |
| **Database Services** | Provisions managed Cloud SQL for PostgreSQL with private connectivity. |
| **Secrets Management** | Integrates Google Secret Manager for centralized secret storage and access. |
| **GitOps Foundation** | Deploys Argo CD to enable GitOps-based platform and application delivery. |
| **Ingress & Traffic Management** | Deploys Gateway API and NGINX Gateway Fabric for Kubernetes traffic management. |
| **Certificate Management** | Automates TLS certificate lifecycle using cert-manager. |
| **External Secrets** | Synchronizes secrets from Google Secret Manager into Kubernetes using External Secrets Operator. |
| **Policy Enforcement** | Enforces Kubernetes security and governance policies with Kyverno. |
| **Observability** | Deploys Prometheus and Grafana for metrics collection, visualization, and monitoring. |
| **Event-Driven Autoscaling** | Enables workload autoscaling using Kubernetes Event-Driven Autoscaling (KEDA). |
| **Progressive Delivery** | Supports canary and blue-green deployments using Argo Rollouts. |
| **Cost Optimization** | Provides Kubernetes cost visibility and resource optimization through Kubecost. |
| **Runtime Security** | Implements runtime threat detection and behavioral monitoring with Falco. |
| **Backup & Disaster Recovery** | Enables backup, restore, and disaster recovery using Velero. |
| **Enterprise Secrets Platform** | Deploys HashiCorp Vault for advanced secrets management and secure workload authentication. |

---
## Sceenshots 

<p align="left">
  <img src="docs/images/vpc-network.png" width="550" alt="VPC">
</p>

<p align="left">
  <img src="docs/images/service-accounts.png" width="550" alt="Service Accounts">
</p>

<p align="left">
  <img src="docs/images/nodes.png" width="550" alt="Nodes">
</p>

<p align="left">
  <img src="docs/images/node-pools.png" width="550" alt="Nodes">
</p>

<p align="left">
  <img src="docs/images/cloud-sql.png" width="550" alt="Cloud SQL">
</p>

<p align="left">
  <img src="docs/images/artifact-repository.png" width="550" alt="Artifact Repository">
</p>

<p align="left">
  <img src="docs/images/iam-accounts.png" width="550" alt="IAM Accounts">
</p>

---
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
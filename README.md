# platform-infra

Infrastructure as Code (IaC) for the [gitops-platform-engineering](https://github.com/stackcouture/gitops-platform-engineering) portfolio project. This repository provisions and manages the complete **Google Cloud Platform (GCP)** infrastructure required to run a GitOps-driven microservices platform — including VPC networking, a GKE Kubernetes cluster, Artifact Registry, IAM service accounts, and Cloud Storage — using **Terraform** with a reusable modules-based structure.

---
## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Folder Structure](#folder-structure)
- [Modules In Detail](#modules-in-detail)
  - [networking](#-module-networking)
  - [gke](#-module-gke)
  - [artifact-registry](#-module-artifact-registry)
  - [iam](#-module-iam)
  - [cloud-storage](#-module-cloud-storage)
- [Root-Level Files](#root-level-files)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)


---

## Overview

This repo is the **infrastructure layer** of a three-repo GitOps platform:

| Repo                             | Role                                          |
|----------------------------------|-----------------------------------------------|
| **`platform-infra`** (this repo) | Terraform — provisions all GCP infrastructure |
| `voting-app`                     | Application source code + CI image builds     |
| `gitops-microservices-platform`  | ArgoCD manifests — desired Kubernetes state   |

`platform-infra` is always provisioned first. It creates the VPC, GKE cluster, Artifact Registry for container images, IAM service accounts with least-privilege permissions, and a Cloud Storage bucket for Terraform remote state. Once the cluster is up, ArgoCD (deployed via `gitops-microservices-platform`) takes over managing all application deployments.

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│            Google Cloud Platform  (asia-south1)             │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐   │
│  │           VPC  (module: networking)                  │   │
│  │                                                      │   │
│  │     ┌─────────────────────────┐                      │   │
│  │     │     Private Subnet      │                      │   │
│  │     │  (asia-south1)          │                      │   │
│  │     │                         │                      │   │
│  │     │  ┌────────────────────┐ │                      │   │
│  │     │  | GKE Node Pool      │ │                      │   │
│  │     │  │   (module: gke)    │ │                      │   │
│  │     │  └────────────────────┘ │                      │   │
│  │     └─────────────────────────┘                      │   │
│  │                                                      │   │
│  │   ┌──────────────────────────────────────────────┐   │   │
│  │   │   GKE Control Plane  (Google Managed)        │   │   │
│  │   └──────────────────────────────────────────────┘   │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌──────────────────────┐   ┌───────────────────┐           │
│  │   Artifact Registry  │   │   Cloud Storage   │           │
│  │  (module: artifact-  │   │   (module: cloud- │           │
│  │   registry)          │   │    storage)       │           │
│  │  Docker image store  │   │  Terraform state  │           │
│  └──────────────────────┘   └───────────────────┘           │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐  │
│  │                    IAM  (module: iam)                 │  │
│  │ GKE SA │ Artifact Registry SA │ GitHub Actions WIF SA │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                            │
                            │  kubectl / ArgoCD sync
                            ▼
                ┌───────────────────────┐
                │  ArgoCD (in-cluster)  │
                │  Watches gitops-      │
                │  microservices-       │
                │  platform repo        │
                └───────────────────────┘
```
**Data flow:**
1. `networking` module creates the VPC, subnets, Cloud Router, and Cloud NAT
2. `gke` module provisions the cluster and node pool inside the private subnet
3. `artifact-registry` module creates the Docker registry for storing app images
4. `iam` module provisions service accounts and binds roles for GKE nodes, CI pipelines, and GitHub Actions
5. `cloud-storage` module creates a GCS bucket used as Terraform remote state backend

---
## Folder Structure

```
platform-infra/
└── terraform/
    ├── environments                      
    |   |
    |   ├── dev    
    |   |    ├── networking/
    |   |    |      ├── .gitignore
    |   │    |      ├── main.tf
    |   |    |      ├── outputs.tf
    |   |    |      ├── provider.tf 
    |   │    |      └── variables.tf
    |   |    ├── gke/
    |   |    |      ├── .gitignore
    |   │    |      ├── main.tf
    |   |    |      ├── outputs.tf
    |   |    |      ├── provider.tf 
    |   │    |      └── variables.tf
    |   |    ├── artifact-registry/ 
    |   |    |      ├── .gitignore
    |   │    |      ├── main.tf
    |   |    |      ├── outputs.tf
    |   |    |      ├── provider.tf 
    |   │    |      └── variables.tf
    |   |    ├── iam/   
    |   |    |      ├── .gitignore
    |   │    |      ├── main.tf
    |   |    |      ├── outputs.tf
    |   |    |      ├── provider.tf 
    |   │    |      └── variables.tf
    |   |    └── cloud-storage/
    |   |    |      ├── .gitignore
    |   │    |      ├── main.tf
    |   |    |      ├── outputs.tf
    |   |    |      ├── provider.tf 
    |   │    |      └── variables.tf
    |   |
    |   └── prod
    │
    └── modules/
        │
        ├── networking/              # VPC, subnets, firewall rules
        │   ├── main.tf
        │   ├── variables.tf
        │   └── outputs.tf
        │
        ├── gke/                     # GKE cluster, node pool, cluster autoscaler
        │   ├── main.tf
        │   ├── variables.tf
        │   └── outputs.tf
        │
        ├── artifact-registry/       # Artifact Registry Docker repository
        │   ├── main.tf
        │   ├── variables.tf
        │   └── outputs.tf
        │
        ├── iam/                     # Service accounts, IAM role bindings, Workload Identity
        │   ├── main.tf
        │   ├── variables.tf
        │   └── outputs.tf
        │
        └── cloud-storage/           # GCS bucket for Terraform remote state & artefacts
            ├── main.tf
            ├── variables.tf
            └── outputs.tf
```
---
## Modules In Detail

### 📦 Module: `networking`

**Path:** `terraform/modules/networking/`

Provisions the complete GCP network stack that the GKE cluster and other services run inside.

**What it creates:**

| Resource      | Details                                                                       |
|---------------|-------------------------------------------------------------------------------|
| VPC Network   | Custom mode VPC — no auto-created subnets                                     |
| Private Subnet| For GKE nodes — `asia-south1`, with secondary IP ranges for Pods and Services |
| Firewall Rules | Allow internal cluster traffic; deny unauthorised external access            |

**Key variables:**

```hcl
variable "project_id" {}
variable "region_name" {}
variable "zone_name" { }
variable "vpc_name" {}
variable "auto_create_subnetworks" {}
variable "routing_mode" {}
variable "subnetwork_name" {}
variable "subnetwork_ip_cidr_range" {}
variable "allow_internal_firewall_rule_name" {}
variable "allow_external_firewall_rule_name" {}
variable "allow_gke_rule_name" {}
```

**Key outputs:**
- `vpc_name` — consumed by `gke` module
- `subnet_name` — consumed by `gke` module
---
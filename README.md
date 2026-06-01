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
### 📦 Module: `gke`

**Path:** `terraform/modules/gke/`

Provisions a private GKE cluster with a managed node pool. GKE nodes run inside the private subnet with no public IP addresses. Access to the Kubernetes API server is restricted to authorised networks.

**What it creates:**

| Resource          | Details                                                  |
|-------------------|----------------------------------------------------------|
| GKE Cluster       | Private cluster; master authorised networks configured   |
| Default Node Pool | Removed immediately (replaced by custom node pool)       |
| Custom Node Pool  | Auto-scaling node pool in the private subnet             |
| Workload Identity | Binds GCP service accounts to Kubernetes service accounts|
| Cluster Autoscaler| Scales nodes up/down based on pod demand                 |

**Key variables:**

```hcl
variable "project_id"         {}
variable "region"             { default = "asia-south1" }
variable "cluster_name"       { default = "gitops-platform-cluster" }
variable "min_node_count"     { default = 1 }
variable "max_node_count"     { default = 3 }
variable "initial_node_count" { default = 2 }
variable "vpc_name"           {}   # from networking module output
variable "subnet_name"        {}   # from networking module output
variable "pods_range_name"    {}   # from networking module output
variable "services_range_name"{}   # from networking module output
```

**Key outputs:**
- `cluster_name` — used for `gcloud container clusters get-credentials`
- `cluster_endpoint` — Kubernetes API server endpoint
- `cluster_ca_certificate` — used for authenticating kubectl

---
### 📦 Module: `artifact-registry`

**Path:** `terraform/modules/artifact-registry/`

Provisions a private Docker container registry in GCP Artifact Registry. All application container images built by the `voting-app` CI pipeline are pushed here and pulled by GKE nodes.

**What it creates:**

| Resource | Details |
|----------|---------|
| Artifact Registry Repository | Docker format, private, in `asia-south1` |
| IAM Bindings | GKE node service account granted `artifactregistry.reader` role |
| IAM Bindings | CI/CD service account granted `artifactregistry.writer` role |

**Key variables:**

```hcl
variable "project_id"       {}
variable "region"           {}
variable "repository_id"    {}
variable "description"      {}
```

**Key outputs:**
- `repository_url` — full Docker registry URL (e.g. `asia-south1-docker.pkg.dev/<project>/gitops-platform-registry`)
  Used in CI workflows to push and pull images

---
### 📦 Module: `iam`

**Path:** `terraform/modules/iam/`

Manages all GCP service accounts and IAM role bindings for the platform. Follows the principle of least privilege — each service account only has the permissions it needs.

**What it creates:**

| Resource                    | Details                                                    |
|-----------------------------|------------------------------------------------------------|
| GKE Node Service Account    | Used by GKE worker nodes; `logging.logWriter`,             |
|                             |  `monitoring.metricWriter`, `artifactregistry.reader`      | 
| CI/CD Service Account       | Used by GitHub Actions; `artifactregistry.writer`,         |
|                             | `container.developer`                                      |
| Workload Identity Binding   | Maps the CI/CD GCP SA to a Kubernetes SA for keyless auth  |
| GitHub Actions WIF Provider | Workload Identity Federation — allows GitHub Actions to    |
|                             |  authenticate without a key file                           |
| IAM Role Bindings           | Scoped role bindings for each service account              |

**Key variables:**

```hcl
variable "project_id"         {}
variable "project_number"     {}
variable "gke_sa_name"        {}
variable "ci_sa_name"         {}
variable "github_org"         {}
variable "github_repo"        {}
```

**Key outputs:**
- `gke_node_sa_email` — attached to the GKE node pool (consumed by `gke` module)
- `ci_sa_email` — used by GitHub Actions workflows for image push
- `workload_identity_provider` — full WIF provider resource name for GitHub Actions

---
### 📦 Module: `cloud-storage`

**Path:** `terraform/modules/cloud-storage/`

Provisions a GCS (Google Cloud Storage) bucket used as the Terraform remote state backend. This ensures state is stored securely, remotely, and supports state locking to prevent concurrent applies.

**What it creates:**

| Resource          | Details                                                                 |
|-------------------|-------------------------------------------------------------------------|
| GCS Bucket        | Versioning enabled, uniform bucket-level access, `asia-south1`          |
| Bucket Versioning | Retains previous state file versions for rollback                       |
| Lifecycle Rules   | Cleans up old non-current state versions after a configurable retention |
|                   | period                                                                  |
| IAM Binding       | Grants the CI/CD service account access to read/write state             |

**Key variables:**

```hcl
variable "project_id"         {}
variable "region"             {}
variable "bucket_name"        {}
variable "retention_days"     {}
```

**Key outputs:**
- `bucket_name` — referenced in `backend.tf` as the remote state bucket

---
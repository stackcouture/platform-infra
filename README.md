# platform-infra

Infrastructure as Code (IaC) for the [platform-engineering-portfolio](https://github.com/stackcouture/platform-engineering-portfolio) project. This repository provisions and manages the complete **Google Cloud Platform (GCP)** infrastructure required to run a GitOps-driven microservices platform — including VPC networking, a GKE Kubernetes cluster, Artifact Registry, IAM service accounts, and Cloud Storage — using **Terraform** with a reusable modules-based structure.

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
- [How to run (demo)](#how-to-run-demo)


---

## Overview

The Platform Infrastructure repository provisions and manages the foundational cloud infrastructure for a production-oriented Kubernetes platform on `Google Cloud Platform (GCP)`. Infrastructure is defined entirely as code using Terraform, enabling consistent, repeatable, and auditable deployments across environments.

This repository establishes the core platform services required before platform components and applications can be deployed. It includes `networking, Kubernetes infrastructure, identity and access management, container registry, storage, cloud-sql`, and supporting cloud services that serve as the foundation for `GitOps-based application delivery`.

The infrastructure is implemented using reusable Terraform modules following `Infrastructure as Code (IaC)` best practices, with an emphasis on modularity, security, scalability, and maintainability.

---
## Objectives

The primary objectives of this repository are to:

- Provision cloud infrastructure using reusable Terraform modules
- Establish a secure and scalable Kubernetes foundation
- Standardize infrastructure deployment through Infrastructure as Code
- Enable GitOps-based platform and application delivery
- Implement secure identity management using Workload Identity
- Support production-oriented operational practices
- Maintain infrastructure consistency across environments

---
## Scope

This repository is responsible for provisioning and managing the cloud infrastructure required by the platform, including:

- Virtual Private Cloud (VPC)
- Private networking
- Regional Google Kubernetes Engine (GKE) cluster
- Node pool configuration
- Google Artifact Registry
- Cloud Storage resources
- Identity and Access Management (IAM)
- Service Accounts
- Workload Identity Federation
- Terraform remote state backend
- Supporting networking resources

Platform services such as `Argo CD, Argo Rollouts, Monitoring, External-secrets, Falco, Keda, Kubecost, Kyverno, vault, Velero, Gateway-api, Policy enforcement(Kyverno), and application workloads` are managed independently after the infrastructure has been provisioned.

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
6. `cloud-sql` module creates the Postgres Managed service
7. `platform-services`

---
## Infrastructure Components

### Networking

Establishes the networking foundation for the platform by provisioning a dedicated Virtual Private Cloud (VPC), subnets, routing, firewall rules, Cloud Router, and Cloud NAT. The networking architecture enables secure communication between Google Cloud services while supporting private connectivity for platform components and managed services.

---
### Google Kubernetes Engine

Provisions a regional Google Kubernetes Engine (GKE) cluster that serves as the runtime environment for the platform. The cluster is configured with dedicated node pools to isolate system services, platform components, and application workloads, enabling scalable and resilient Kubernetes operations.

The infrastructure provides the foundation for deploying platform services and applications through a GitOps workflow.

---
### Platform Workloads

The provisioned Kubernetes platform hosts the core operational services required to support application delivery and cluster management. These services include GitOps controllers, ingress and gateway components, certificate management, observability, policy enforcement, cost monitoring, external secrets integration, progressive delivery, and other shared platform capabilities.

Platform workloads are deployed independently after the infrastructure has been provisioned, ensuring a clear separation between infrastructure provisioning and platform operations.
---
### Cloud SQL for PostgreSQL

Provisions a managed PostgreSQL database using Google Cloud SQL to provide a reliable, secure, and operationally managed relational database service for platform applications.

The infrastructure automates database provisioning, private networking integration, storage configuration, backup policies, and lifecycle management while leveraging Google Cloud's managed database capabilities for maintenance, patching, and high availability.
---
### Identity and Access Management

Implements dedicated service accounts and least-privilege Identity and Access Management (IAM) policies to secure platform resources. Access permissions are granted based on operational responsibilities, reducing the overall attack surface while supporting secure platform administration.

---
### Workload Identity Federation

Configures Workload Identity Federation to allow Kubernetes workloads to securely access Google Cloud services without relying on long-lived service account keys. This approach improves security, simplifies credential management, and aligns with Google Cloud recommended authentication practices.

---
### Artifact Registry

Creates private Artifact Registry repositories used to securely store and distribute container images generated by the continuous integration pipeline. These repositories serve as the trusted image source for GitOps-managed deployments running on the Kubernetes platform.

---
### Cloud Storage

Provisions Cloud Storage buckets used for Terraform remote state management and additional platform storage requirements. Remote state enables collaborative infrastructure management while ensuring state consistency, versioning, and centralized storage.

---
### Secret Management

Integrates Google Secret Manager to centrally manage sensitive configuration values, API keys, credentials, and certificates required by infrastructure and platform services. Secrets remain external to source control and are securely consumed by workloads through platform integrations.

---

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

## How to run (demo)

This repo provisions the **GCP infrastructure layer**. Apply Terraform first, then bootstrap Argo CD from the GitOps repo to install platform services and deploy applications.

> **Note:** Use a dedicated GCP project for demo/testing. Terraform will create billable resources (GKE, Cloud SQL, load balancers, etc.).

### Prerequisites

- **GCP**
  - A GCP project with billing enabled
  - Permissions to create VPC, GKE, IAM, Artifact Registry, Cloud SQL, and GCS
- **CLI tools**
  - `gcloud`
  - `terraform`
  - `kubectl`
- **Authentication**

```bash
gcloud auth login
gcloud auth application-default login
gcloud config set project <PROJECT_ID>
gcloud config set compute/region <REGION>
```



### Provision order (Terraform)

Apply stacks in this order to satisfy dependencies.

> Paths below assume you run commands from the repo root.

1) **networking**

```bash
cd terraform/environments/dev/networking
terraform init
terraform apply
```

2) **iam**

```bash
cd ../iam
terraform init
terraform apply
```

3) **gke**

```bash
cd ../gke
terraform init
terraform apply
```

4) **artifact-registry**

```bash
cd ../artifact-registry
terraform init
terraform apply
```

5) **cloud-sql** and **storage**

```bash
cd ../cloud-sql
terraform init
terraform apply

cd ../storage/cloud-storage
terraform init
terraform apply
```

### Configure kubectl for GKE

```bash
gcloud container clusters get-credentials <CLUSTER_NAME> --region <REGION> --project <PROJECT_ID>
kubectl get nodes
```

### GitOps bootstrap (Argo CD)

After the cluster is ready, bootstrap Argo CD and apply the GitOps configuration from:

- `https://github.com/stackcouture/gitops-microservices-platform`

That repo becomes the single source of truth for platform services (Gateway API, External Secrets, Kyverno, monitoring, etc.) and application deployments.

### Cleanup

Destroy in reverse order to reduce dependency issues:

```bash
# Optional: remove Argo CD applications first (so LBs/NEGs clean up)
# Then run terraform destroy per stack in reverse order
```
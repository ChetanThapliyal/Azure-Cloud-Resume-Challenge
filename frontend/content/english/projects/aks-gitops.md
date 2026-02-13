---
title: "Microservices Deployment on AKS with GitOps"
date: 2024-06-14T00:00:00+06:00
image : "images/projects/aks-gitops.png"
draft: false
description: "Implementing GitOps principles to deploy microservices on Azure Kubernetes Service."
---

Implementation of an advanced CI/CD pipeline utilizing Azure Pipelines and Argo CD for a multi-microservice application on Azure Kubernetes Service (AKS).

## Architecture

- **Application**: Sample microservice voting application
- **Platform**: Azure Kubernetes Service (AKS)
- **CI/CD**: Azure DevOps Pipelines for build and test
- **GitOps**: ArgoCD for continuous deployment, keeping deployed state in sync with Git
- **Containerization**: Docker for service packaging

## Challenges Solved

- Complex multi-service deployment management
- Maintaining consistency between desired and actual state
- Scalability and reliability across environments
- Efficient automated CI/CD pipeline

[View on GitHub](https://github.com/ChetanThapliyal/Argocd-AKS-microservices-deployment) | [Blog Post](https://blog.chetan-thapliyal.cloud/micro-service-deployment-using-aks-and-argocd)

---
title: "Secure CI/CD Pipeline"
date: 2024-03-14T00:00:00+06:00
image : "images/projects/secure-cicd.png"
draft: false
description: "A comprehensive DevSecOps pipeline integrating Jenkins, SonarQube, Trivy, and Kubernetes."
---

A security-centric CI/CD pipeline built with Jenkins, integrating multiple security scanning tools and deploying to Kubernetes on GCP.

## Key Components

- **CI/CD**: Jenkins pipeline with multi-stage build and deploy
- **Code Quality**: SonarQube for static code analysis
- **Security Scanning**: Aqua Trivy for container vulnerability scanning, Kubeaudit for Kubernetes security
- **Artifact Management**: Nexus Repository and Docker Hub
- **Infrastructure**: GCP with Terraform-provisioned resources
- **Orchestration**: Kubernetes for container orchestration

[View on GitHub](https://github.com/ChetanThapliyal/Secure-cloudNative-CI-CD-pipeline) | [Blog Post](https://blog.chetan-thapliyal.cloud/implementing-a-security-centric-cloud-native-cicd-pipeline-a-real-world-demonstration-using-terraform-and-gcp)

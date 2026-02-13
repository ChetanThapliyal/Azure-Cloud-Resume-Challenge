---
title: "Deploying and Scaling 3-tier App with GKE"
date: 2024-07-01T00:00:00+06:00
image : "images/projects/3-tier-gke.png"
draft: false
description: "Deploying a scalable 3-tier web application architecture on Google Kubernetes Engine."
---

Deploying a YelpCamp application — a 3-tier full-stack website for campground reviews — across various environments using Cloud DevOps practices on GKE.

## Architecture

- **Frontend**: Dynamic web app for campground management with image uploads
- **Backend**: Node.js application handling user registration, camp creation, and reviews
- **Database**: MongoDB for data persistence
- **Infrastructure**: GKE cluster provisioned with Terraform
- **CI/CD**: Jenkins pipeline with Docker builds and Trivy security scanning
- **Environments**: Development, staging, and production configurations

[View on GitHub](https://github.com/ChetanThapliyal/3-tier-architecture-deployment-GKE) | [Blog Post](https://blog.chetan-thapliyal.cloud/3-tier-architecture-multi-environment-deployment-using-terraform-jenkins-docker-and-gke)

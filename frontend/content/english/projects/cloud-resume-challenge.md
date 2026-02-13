---
title: "Cloud Resume Challenge (Azure)"
date: 2024-05-14T00:00:00+06:00
image : "images/projects/cloud-resume.jpg"
draft: false
description: "Full-stack serverless resume website on Microsoft Azure with CI/CD and infrastructure as code."
---

A full-stack serverless web application that serves as a personal resume website, showcasing cloud engineering skills by building and deploying a complete solution entirely on **Microsoft Azure**.

## Architecture

- **Frontend**: Static website (HTML, CSS, JavaScript) hosted on Azure Storage, served via Azure CDN
- **Backend**: Serverless API built with Azure Functions (Python) for visitor counter
- **Database**: Azure Cosmos DB for persistent visitor count storage
- **Infrastructure as Code**: All resources provisioned with Terraform
- **CI/CD**: GitHub Actions for automated deployment
- **Security**: HTTPS with custom domain, Application Insights for monitoring

[View on GitHub](https://github.com/ChetanThapliyal/Azure-Cloud-Resume-Challenge)

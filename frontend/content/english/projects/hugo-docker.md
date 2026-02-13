---
title: "Hugo Portfolio with Multistage Docker Builds"
date: 2023-12-14T00:00:00+06:00
image : "images/projects/hugo-docker.png"
draft: false
description: "Optimizing a Hugo site deployment using multi-stage Docker builds for minimal image size."
---

Optimizing Docker images for a Hugo website (portfolio) using multi-stage builds, dramatically reducing image size while maintaining full functionality.

## Approach

- **Multi-stage Build**: Separate build and runtime stages for minimal final image
- **Hugo**: Static site generation for the portfolio
- **Docker**: Containerized deployment with optimized layers
- **Size Optimization**: Significant reduction in image size compared to single-stage builds

[View on GitHub](https://github.com/ChetanThapliyal/hugo-portfolio-multistage-docker) | [Blog Post](https://blog.chetan-thapliyal.cloud/optimizing-docker-images-with-multistage-builds-a-hugo-portfolio-example)

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Goal

Provision a Docker-based cluster on an AWS EC2 instance using Terraform. The cluster consists of multiple web servers (nginx) behind a round-robin load balancer, each exposing a `/health` endpoint.

## Common Commands

```powershell
# Initialize Terraform and download providers/plugins
terraform init

# Preview changes
terraform plan

# Apply infrastructure
terraform apply

# Destroy infrastructure
terraform destroy

# Lint
tflint --init
tflint --recursive

# Security scan
trivy config .

# Pre-commit (runs trivy on commit)
pre-commit install
pre-commit run --all-files
```

## Architecture

- [terraform.tf](terraform.tf) — Terraform version constraint and AWS provider pin (`~> 5.92`)
- [main.tf](main.tf) — AWS resources: AMI data source, EC2 instance, security groups
- Region: `il-central-1`
- AMI: latest Amazon Linux 2 (`amzn2-ami-hvm-*-x86_64-gp2`, owner: `amazon`)

## Tooling

- **tflint** — Terraform linter with AWS ruleset, config in [.tflint.hcl](.tflint.hcl)
- **trivy** — Security scanner (replaces tfsec), runs as pre-commit hook via `antonbabenko/pre-commit-terraform`
- **GitHub Actions** — tflint runs on every push/PR; failures are allowed on push but block PRs (`.github/workflows/tflint.yml`)
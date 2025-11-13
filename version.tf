terraform {
  required_version = ">= 1.0"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

# Configure GitHub provider
provider "github" {
  token = var.github_token
  owner = var.github_organization
}
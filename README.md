# GitHub Repository Ruleset Terraform Module

A Terraform module that automates the creation and management of GitHub repository rulesets to enforce branch protection, pull request requirements, and code quality standards.

## What This Module Does

This module creates a GitHub repository ruleset that:

- **Protects your main branch** from deletion and direct pushes
- **Enforces status checks** before merging (terraform fmt, tflint, validate, checkov)
- **Requires pull request reviews** with customizable approval requirements
- **Supports bypass actors** for administrative access when needed

## Requirements

- **Terraform** >= 1.0
- **GitHub Provider** ~> 6.0
- **GitHub Token** with `repo` and `admin:org` scopes
- **Public repository** OR **GitHub Pro/Team/Enterprise** for private repositories

## Quick Setup

### GitHub Actions

**Deploy to ALL repositories in your organization automatically:**

1. Go to the repository's **Actions** tab
2. Select **"Deploy GitHub Rulesets to All Repositories"**
3. Click **"Run workflow"** and configure:
   - **Ruleset Name**: `Organization-Wide-PR-Checks`
   - **Target Repositories**: _(leave empty for all repos)_
   - **Dry Run**: `true` _(for testing)_

#### How It Works

**Repository Discovery**: The workflow automatically discovers all repositories in your organization using the GitHub API, filtering out archived, disabled, and empty repositories.

**Dynamic Configuration**: For each repository, the workflow creates a unique Terraform state file and generates repository-specific `terraform.tfvars` using the organization owner and repository name automatically.

**Deployment**: Runs `terraform plan` to preview changes and applies rulesets only if changes are detected, reporting success/failure for each repository.

#### Examples

**Deploy to all repositories:**

- Ruleset Name: `Branch-Protection-2024`
- Target Repositories: _(leave empty)_
- Dry Run: `false`

**Deploy to specific repositories:**

- Ruleset Name: `Critical-Repos-Protection`
- Target Repositories: `repo1,repo2,repo3`
- Dry Run: `false`

**Test run (preview only):**

- Ruleset Name: `Test-Ruleset`
- Target Repositories: _(leave empty)_
- Dry Run: `true`

#### Default Ruleset Configuration

The workflow applies these default rules to each repository:

**Branch Protection:**

- **Deletion protection**: Prevents branch deletion
- **Default branch targeting**: Applies to the repository's default branch

**Required Status Checks:**

- `terraform fmt` - Code formatting validation
- `tflint` - Terraform linting
- `terraform validate` - Configuration validation
- `checkov` - Security and compliance scanning

**Pull Request Rules:**

- **Required approvals**: 1 reviewer required
- **Dismiss stale reviews**: Yes (when new commits are pushed)
- **Code owner review**: Not required
- **Last push approval**: Required
- **Resolve discussions**: All review threads must be resolved

#### Security

The default `GITHUB_TOKEN` automatically has the required permissions for repositories within the same organization:

- **Read repository metadata**
- **Create and modify repository rulesets**
- **Access organization repository lists**
- **24-hour token expiration** (automatic security)

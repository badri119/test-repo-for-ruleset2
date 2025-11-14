# GitHub Repository Ruleset Terraform Module

A Terraform module that automates the creation and management of GitHub repository rulesets to enforce branch protection, pull request requirements, and code quality standards across multiple repositories.

## What This Module Does

This module creates GitHub repository rulesets that:

- 🛡️ **Protects your main branch** from deletion and direct pushes
- ✅ **Enforces status checks** before merging (terraform fmt, tflint, validate, checkov)
- 📋 **Requires pull request reviews** with customizable approval requirements
- 🔒 **Supports bypass actors** for administrative access when needed
- 📊 **Manages multiple repositories** from a single configuration

## Requirements

- **Terraform** >= 1.0
- **GitHub Provider** ~> 6.0
- **GitHub Token** with `repo` and `admin:org` scopes
- **Public repository** OR **GitHub Pro/Team/Enterprise** for private repositories
- **Terraform Cloud** account (recommended for state management)

## Quick Setup with Terraform Cloud

### 1. Create Terraform Cloud Workspace

1. **Sign up/Login** to [Terraform Cloud](https://app.terraform.io/)
2. **Create Organization** (if needed)
3. **Create Workspace**:
   - Choose "Version control workflow"
   - Connect to this GitHub repository
   - Name: `github-rulesets-deployment`

### 2. Configure Variables

In your Terraform Cloud workspace, set these variables:

#### Terraform Variables:

```hcl
github_organization = "your-github-org"
ruleset_name       = "Repository-PR-Checks"
target_repositories = ["repo1", "repo2", "repo3"]
```

#### Environment Variables:

```bash
TF_VAR_github_token = "your-github-pat-token"  # Mark as SENSITIVE
```

### 3. Deploy

1. Click **"Start new run"** in Terraform Cloud
2. Review the plan
3. **Apply** to create rulesets

## Usage Examples

**Deploy to multiple repositories:**

```hcl
target_repositories = ["my-app", "my-api", "my-frontend"]
```

**Add a new repository:**

```hcl
target_repositories = ["my-app", "my-api", "my-frontend", "my-new-service"]
```

_Terraform will create ruleset for the new repository only (incremental)_

**Remove a repository:**

```hcl
target_repositories = ["my-app", "my-api"]  # removed my-frontend
```

_Terraform will destroy the ruleset for the removed repository_

**Modify all rulesets:**

- Change `ruleset_name` or other variables
- Terraform will update all existing rulesets

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

## Benefits of Terraform Cloud Approach

✅ **Native State Management**: Built-in remote state with locking and versioning
✅ **Change History**: Full audit trail of all infrastructure changes
✅ **Team Collaboration**: Multiple team members can manage rulesets
✅ **Variable Management**: Secure storage for sensitive values like GitHub tokens
✅ **Drift Detection**: Can detect manual changes to rulesets outside Terraform
✅ **Policy as Code**: Can add Sentinel policies for governance
✅ **Incremental Updates**: Only changes what's needed when you modify the repository list

## Security & Token Management

**GitHub Personal Access Token**: Set as `TF_VAR_github_token` in Terraform Cloud workspace

- ✅ **Secure storage**: Token stored encrypted in Terraform Cloud
- ✅ **Scoped permissions**: Only `repo` and `admin:org` access needed
- ✅ **Team access control**: Control who can view/modify configurations
- ✅ **Audit logs**: All token usage tracked in Terraform Cloud runs

For detailed setup instructions, see: [terraform-cloud-setup.md](terraform-cloud-setup.md)

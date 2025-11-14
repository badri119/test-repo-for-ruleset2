# Terraform Cloud Setup Guide

## Overview

Run the GitHub rulesets module directly from Terraform Cloud instead of GitHub Actions for better state management and native Terraform workflows.

## Setup Steps

### 1. Create Terraform Cloud Workspace

1. **Sign up/Login** to [Terraform Cloud](https://app.terraform.io/)
2. **Create Organization** (if needed)
3. **Create Workspace**:
   - Choose "Version control workflow"
   - Connect to this GitHub repository
   - Name: `github-rulesets-deployment`

### 2. Configure Workspace Variables

In your Terraform Cloud workspace, add these variables:

#### Terraform Variables:

```hcl
# Required
github_organization = "your-github-org"        # String
ruleset_name       = "Repository-PR-Checks"    # String

# Repository targeting - choose one approach:
# Approach A: List of repositories
target_repositories = ["repo1", "repo2", "repo3"]  # List(string)

# Approach B: Repository configuration map (more advanced)
repository_configs = {
  "repo1" = {
    ruleset_name = "Critical-App-Rules"
    enforcement  = "active"
  }
  "repo2" = {
    ruleset_name = "Standard-Rules"
    enforcement  = "evaluate"
  }
}
```

#### Environment Variables:

```bash
# Required - mark as SENSITIVE
TF_VAR_github_token = "your-github-pat-token"
```

### 3. Update Terraform Configuration

The main.tf would be modified to use a dynamic approach:

```hcl
# Use for_each to create rulesets for multiple repositories
resource "github_repository_ruleset" "repositories" {
  for_each = toset(var.target_repositories)

  name        = var.ruleset_name
  repository  = each.value
  target      = var.target
  enforcement = var.enforcement

  conditions {
    ref_name {
      include = var.ref_name_include
      exclude = var.ref_name_exclude
    }
  }

  rules {
    deletion = var.enable_deletion_protection

    # Add other rules as configured...
  }
}
```

### 4. Trigger Options

**Manual Runs:**

- Use Terraform Cloud UI to trigger runs
- Specify different target_repositories for different deployments

**Automated Runs:**

- Configure auto-runs on VCS changes
- Use Terraform Cloud API for programmatic runs

**API-Driven:**

```bash
# Trigger run with specific repositories
curl -X POST "https://app.terraform.io/api/v2/runs" \
  -H "Authorization: Bearer $TFC_TOKEN" \
  -H "Content-Type: application/vnd.api+json" \
  -d '{...}'
```

## Benefits of Terraform Cloud Approach

✅ **Native State Management**: Built-in remote state with locking
✅ **Change History**: Full audit trail of all changes
✅ **Team Collaboration**: Multiple team members can manage
✅ **Variable Management**: Secure storage for sensitive values
✅ **Drift Detection**: Can detect manual changes to rulesets
✅ **Policy as Code**: Can add Sentinel policies for governance
✅ **Cost Estimation**: See impact before applying changes

## Migration from GitHub Actions

1. **Setup Terraform Cloud workspace** (as above)
2. **Remove GitHub Actions workflow** (`.github/workflows/deploy-rulesets.yml`)
3. **Update variables.tf** to include `target_repositories` variable
4. **Update main.tf** to use `for_each` pattern
5. **Test with a small set of repositories first**

## Usage Examples

**Deploy to 3 repositories:**

- Set `target_repositories = ["app1", "app2", "app3"]`
- Click "Start new run" in Terraform Cloud

**Add a new repository:**

- Update `target_repositories = ["app1", "app2", "app3", "app4"]`
- Terraform will create ruleset for app4 only (incremental)

**Remove a repository:**

- Update `target_repositories = ["app1", "app2"]` (removed app3)
- Terraform will destroy ruleset for app3 only

**Modify ruleset for all repositories:**

- Change `ruleset_name` or other variables
- Terraform will update all existing rulesets

# GitHub Provider Configuration
variable "github_token" {
  type        = string
  description = "GitHub personal access token with repo and admin:org scopes"
  sensitive   = true
}

variable "github_organization" {
  type        = string
  description = "GitHub organization name"
  default     = "marvell-aws-ps"
}

# Basic ruleset configuration
variable "ruleset_name" {
  type        = string
  description = "Ruleset for Marvell Repos"
}

variable "repository_name" {
  type        = string
  description = "Name of the repository where the ruleset will be applied"
}

variable "target" {
  type        = string
  description = "The target of the ruleset (branch, tag, or push)"
  default     = "branch"
  validation {
    condition     = contains(["branch", "tag", "push"], var.target)
    error_message = "Target must be one of: branch, tag, push."
  }
}

variable "enforcement" {
  type        = string
  description = "The enforcement level of the ruleset (disabled, active, evaluate)"
  default     = "active"
  validation {
    condition     = contains(["disabled", "active", "evaluate"], var.enforcement)
    error_message = "Enforcement must be one of: disabled, active, evaluate."
  }
}

# Ref name conditions
variable "ref_name_include" {
  type        = list(string)
  description = "List of ref name patterns to include - defaults to default branch"
  default     = ["~DEFAULT_BRANCH"]
}

variable "ref_name_exclude" {
  type        = list(string)
  description = "List of ref name patterns to exclude"
  default     = []
}

# Rule enablement flags
variable "enable_deletion_protection" {
  type        = bool
  description = "Enable deletion protection rule"
  default     = true
}

variable "enable_required_status_checks" {
  type        = bool
  description = "Enable required status checks rule"
  default     = true
}

variable "enable_pull_request_rules" {
  type        = bool
  description = "Enable pull request rules"
  default     = true
}

variable "enable_non_fast_forward_protection" {
  type        = bool
  description = "Enable non-fast-forward protection"
  default     = false
}

variable "enable_required_linear_history" {
  type        = bool
  description = "Enable required linear history"
  default     = false
}

variable "enable_required_signatures" {
  type        = bool
  description = "Enable required signatures"
  default     = false
}

variable "enable_update_protection" {
  type        = bool
  description = "Enable update protection"
  default     = false
}

variable "enable_creation_protection" {
  type        = bool
  description = "Enable creation protection"
  default     = false
}

variable "enable_tag_name_pattern" {
  type        = bool
  description = "Enable tag name pattern rule"
  default     = false
}

# Required status checks parameters
variable "required_status_checks" {
  type = list(object({
    context        = string
    integration_id = number
  }))
  description = "List of required status checks (integration_id can be null)"
  default = [
    {
      context        = "terraform fmt"
      integration_id = null
    },
    {
      context        = "tflint"
      integration_id = null
    },
    {
      context        = "terraform validate"
      integration_id = null
    },
    {
      context        = "checkov"
      integration_id = null
    }
  ]
}

variable "strict_required_status_checks_policy" {
  type        = bool
  description = "Require branches to be up to date before merging"
  default     = true
}

variable "do_not_enforce_on_create" {
  type        = bool
  description = "Do not enforce required status checks on repository creation"
  default     = false
}

# Pull request parameters
variable "required_approving_review_count" {
  type        = number
  description = "Number of required approving reviews"
  default     = 1
}

variable "dismiss_stale_reviews_on_push" {
  type        = bool
  description = "Dismiss stale reviews when new commits are pushed"
  default     = true
}

variable "require_code_owner_review" {
  type        = bool
  description = "Require review from code owners"
  default     = false
}

variable "require_last_push_approval" {
  type        = bool
  description = "Require approval of the most recent reviewable push"
  default     = true
}

variable "required_review_thread_resolution" {
  type        = bool
  description = "Require all review threads to be resolved"
  default     = true
}

variable "allowed_merge_methods" {
  type        = list(string)
  description = "List of allowed merge methods"
  default     = ["merge", "squash", "rebase"]
  validation {
    condition = alltrue([
      for method in var.allowed_merge_methods : contains(["merge", "squash", "rebase"], method)
    ])
    error_message = "Allowed merge methods must be one of: merge, squash, rebase."
  }
}

# Update rule parameters
variable "update_allows_fetch_and_merge" {
  type        = bool
  description = "Allow fetch and merge for update rule"
  default     = false
}

# Tag name pattern parameters
variable "tag_name_pattern" {
  type = object({
    operator = string
    pattern  = string
    name     = string
    negate   = bool
  })
  description = "Tag name pattern configuration"
  default     = null
}

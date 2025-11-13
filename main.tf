resource "github_repository_ruleset" "this" {
  name        = var.ruleset_name
  repository  = var.repository_name
  target      = var.target
  enforcement = var.enforcement

  conditions {
    ref_name {
      include = var.ref_name_include
      exclude = var.ref_name_exclude
    }
  }

  rules {
    # Simple boolean rules
    deletion = var.enable_deletion_protection

    # Required status checks rule
    dynamic "required_status_checks" {
      for_each = var.enable_required_status_checks ? [1] : []
      content {
        dynamic "required_check" {
          for_each = var.required_status_checks
          content {
            context        = required_check.value.context
            integration_id = try(required_check.value.integration_id, null)
          }
        }

        strict_required_status_checks_policy = var.strict_required_status_checks_policy
        do_not_enforce_on_create            = var.do_not_enforce_on_create
      }
    }

    # Pull request rule
    dynamic "pull_request" {
      for_each = var.enable_pull_request_rules ? [1] : []
      content {
        required_approving_review_count    = var.required_approving_review_count
        dismiss_stale_reviews_on_push     = var.dismiss_stale_reviews_on_push
        require_code_owner_review         = var.require_code_owner_review
        require_last_push_approval        = var.require_last_push_approval
        required_review_thread_resolution = var.required_review_thread_resolution
      }
    }
  }

}

# Outputs for multiple repositories
output "rulesets" {
  description = "Map of repository names to their ruleset details"
  value = {
    for repo, ruleset in github_repository_ruleset.repositories : repo => {
      id          = ruleset.id
      name        = ruleset.name
      repository  = ruleset.repository
      target      = ruleset.target
      enforcement = ruleset.enforcement
      node_id     = ruleset.node_id
    }
  }
}

output "repository_count" {
  description = "Number of repositories with rulesets applied"
  value       = length(github_repository_ruleset.repositories)
}

output "target_repositories" {
  description = "List of repositories that have rulesets applied"
  value       = [for repo in github_repository_ruleset.repositories : repo.repository]
}

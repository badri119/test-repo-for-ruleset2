output "ruleset_id" {
  description = "The ID of the created GitHub repository ruleset"
  value       = github_repository_ruleset.this.id
}

output "ruleset_name" {
  description = "The name of the created GitHub repository ruleset"
  value       = github_repository_ruleset.this.name
}

output "ruleset_repository" {
  description = "The repository name where the ruleset is applied"
  value       = github_repository_ruleset.this.repository
}

output "ruleset_target" {
  description = "The target of the ruleset (branch, tag, or push)"
  value       = github_repository_ruleset.this.target
}

output "ruleset_enforcement" {
  description = "The enforcement level of the ruleset"
  value       = github_repository_ruleset.this.enforcement
}

output "ruleset_node_id" {
  description = "The node ID of the created GitHub repository ruleset"
  value       = github_repository_ruleset.this.node_id
}

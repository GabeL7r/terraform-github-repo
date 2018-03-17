output "name" {
  description = "Name of repo"
  value       = "${var.name}"
}

output "webhook_urls" {
  value = ["${github_repository_webhook.repo_webhook.*.url}"]
}

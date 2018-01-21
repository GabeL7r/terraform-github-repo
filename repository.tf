resource "github_repository" "repo" {
  name               = "${var.name}"
  has_issues         = "${var.has_issues}"
  has_wiki           = "${var.has_wiki}"
  gitignore_template = "${var.gitignore_template}"
  allow_merge_commit = "${var.allow_merge_commit}"
  allow_squash_merge = "${var.allow_squash_commit}"
  allow_rebase_merge = "${var.allow_rebase_merge}"
  private            = "${var.private}"
}

# TODO: Add labels
# Note: The branch protections will fail to be created on the first terraform apply
# they will also fail to be created if protecting a branch that does not exist
resource "github_branch_protection" "branches" {
  count          = "${length(var.protected_branches)}"
  repository     = "${var.name}"
  branch         = "${var.protected_branches[count.index]}"
  enforce_admins = true

  required_status_checks {
    strict = "${var.required_status_checks}"
  }

  required_pull_request_reviews {
    dismiss_stale_reviews = "${var.dismiss_stale_reviews}"
  }
}

output "name" {
  description = "Name of repo"
  value = "${var.name}"
}
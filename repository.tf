resource "github_repository" "repo" {
  name               = "${var.name}"
  description        = "${var.description}"
  homepage_url       = "${var.homepage_url}"
  private            = "${var.private}"
  has_issues         = "${var.has_issues}"
  has_wiki           = "${var.has_wiki}"
  allow_merge_commit = "${var.allow_merge_commit}"
  allow_squash_merge = "${var.allow_squash_commit}"
  allow_rebase_merge = "${var.allow_rebase_merge}"
  has_downloads      = false
  auto_init          = "${var.auto_init}"
  gitignore_template = "${var.gitignore_template}"
  license_template   = "${var.license_template}"
  default_branch     = "${var.default_branch}"
}

resource "github_branch_protection" "branches" {
  count          = "${var.protected_branches_enabled ? length(var.protected_branches) : 0}"
  repository     = "${github_repository.repo.name}"
  branch         = "${lookup(var.protected_branches[count.index], "branch")}"
  enforce_admins = "${lookup(var.protected_branches[count.index], "enforce_admins", var.enforce_admins)}"

  required_status_checks {
    strict = "${lookup(var.protected_branches[count.index], "strict", var.required_status_checks_strict)}"

    contexts  = "${compact(concat(var.required_status_checks_contexts, split(",", lookup(var.protected_branches[count.index], "contexts", ""))))}"
  }

  required_pull_request_reviews {
    dismiss_stale_reviews      = "${lookup(var.protected_branches[count.index], "dismiss_stale_reviews", var.dismiss_stale_reviews)}"
    dismissal_users            = "${compact(concat(var.dismissal_users,split(",", lookup(var.protected_branches[count.index], "dismissal_users", ""))))}"
    dismissal_teams            = "${compact(concat(var.dismissal_teams,split(",", lookup(var.protected_branches[count.index], "dismissal_teams", ""))))}"
    require_code_owner_reviews = "${lookup(var.protected_branches[count.index], "require_code_owner_reviews", var.require_code_owner_reviews)}"
  }

  restrictions {
    users = "${compact(concat(var.restriction_users, split(",", lookup(var.protected_branches[count.index], "restriction_users", ""))))}"
    teams = "${compact(concat(var.restriction_teams, split(",", lookup(var.protected_branches[count.index], "restriction_teams", ""))))}"
  }
}

resource "github_repository_deploy_key" "repo_deploy_keys" {
  count      = "${var.deploy_key_enabled ? length(var.deploy_keys) : 0}"
  repository = "${github_repository.repo.name}"
  title      = "${github_repository.repo.name} ${(lookup(var.deploy_keys[count.index], "name"))} key"
  key        = "${lookup(var.deploy_keys[count.index], "key", var.deploy_key)}"
  read_only  = "${lookup(var.deploy_keys[count.index], "read_only", var.deploy_key_read_only)}"
}

resource "github_repository_webhook" "repo_webhooks" {
  count          = "${var.repo_webhook_enabled ? length(var.repo_webhooks) : 0}"

  #count      = "${var.repo_webhook_enabled == true ? length(var.repo_webhooks) : 0}"
  repository = "${github_repository.repo.name}"

  name   = "${lookup(var.repo_webhooks[count.index], "name", var.repo_webhook_name)}"
  events = "${compact(concat(var.repo_webhook_events, split(",", lookup(var.repo_webhooks[count.index], "events", ""))))}"

  configuration {
    url          = "${lookup(var.repo_webhooks[count.index], "url")}"
    content_type = "${lookup(var.repo_webhooks[count.index], "content_type", var.repo_webhook_content_type)}"
    insecure_ssl = "${lookup(var.repo_webhooks[count.index], "insecure_ssl", var.repo_webhook_insecure_ssl)}"
  }

  active = "${lookup(var.repo_webhooks[count.index], "active", var.repo_webhook_active)}"
}

resource "github_repository_collaborator" "pull_collaborators" {
  count      = "${length(var.pull_collaborators)}"
  repository = "${github_repository.repo.name}"
  username   = "${var.pull_collaborators[count.index]}"
  permission = "pull"
}

resource "github_repository_collaborator" "push_collaborators" {
  count      = "${length(var.push_collaborators)}"
  repository = "${github_repository.repo.name}"
  username   = "${var.push_collaborators[count.index]}"
  permission = "push"
}

resource "github_repository_collaborator" "admin_collaborators" {
  count      = "${length(var.admin_collaborators)}"
  repository = "${github_repository.repo.name}"
  username   = "${var.admin_collaborators[count.index]}"
  permission = "admin"
}

resource "github_team_repository" "pull_teams" {
  count      = "${length(var.pull_teams)}"
  team_id    = "${var.pull_teams[count.index]}"
  repository = "${github_repository.repo.name}"
  permission = "pull"
}

resource "github_team_repository" "push_teams" {
  count      = "${length(var.push_teams)}"
  team_id    = "${var.push_teams[count.index]}"
  repository = "${github_repository.repo.name}"
  permission = "push"
}

resource "github_team_repository" "admin_teams" {
  count      = "${length(var.admin_teams)}"
  team_id    = "${var.admin_teams[count.index]}"
  repository = "${github_repository.repo.name}"
  permission = "admin"
}

resource "github_issue_label" "labels" {
  count      = "${length(var.labels)}"
  repository = "${github_repository.repo.name}"
  name       = "${lookup(var.labels[count.index], "name")}"
  color      = "${lookup(var.labels[count.index], "color")}"
}

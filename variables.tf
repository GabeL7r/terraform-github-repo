#--------------------------------------------------------------
# Repo Variables
#--------------------------------------------------------------
variable "name" {}

variable "description" {}

variable "homepage_url" {
  default = ""
}

variable "private" {
  default = true
}

variable "has_issues" {
  default = true
}

variable "has_wiki" {
  default = true
}

variable "allow_merge_commit" {
  default = false
}

variable "allow_squash_commit" {
  default = true
}

variable "allow_rebase_merge" {
  default = false
}

variable "auto_init" {
  default = false
}

variable "gitignore_template" {
  default = ""
}

variable "license_template" {
  default = ""
}

variable "default_branch" {
  default = "master"
}

#--------------------------------------------------------------
# Branch Protection Variables
#--------------------------------------------------------------
variable "protected_branches_enabled" {
  default = true
}

variable "protected_branches" {
  type = "list"

  default = [{
    branch = "master"
  }]
}

variable "enforce_admins" {
  default = true
}

variable "required_status_checks_strict" {
  default = false
}

variable "required_status_checks_contexts" {
  type    = "list"
  default = ["default"]
}

variable "dismiss_stale_reviews" {
  default = false
}

variable "dismissal_users" {
  type    = "list"
  default = []
}

variable "dismissal_teams" {
  type    = "list"
  default = []
}

variable "require_code_owner_reviews" {
  default = true
}

variable "restriction_users" {
  type    = "list"
  default = []
}

variable "restriction_teams" {
  type    = "list"
  default = []
}

#--------------------------------------------------------------
# Deploy Variables
#--------------------------------------------------------------

variable "deploy_key_enabled" {
  default = false
}

variable "deploy_keys" {
  type    = "list"
  default = []
}

variable "deploy_key" {
  default = ""
}

variable "deploy_key_read_only" {
  default = true
}

#--------------------------------------------------------------
# Webhook Variables
#--------------------------------------------------------------
variable "repo_webhook_enabled" {
  default = false
}

variable "repo_webhooks" {
  type    = "list"
  default = []
}

variable "repo_webhook_name" {
  default = "jenkins"
}

variable "repo_webhook_events" {
  type    = "list"
  default = ["push"]
}

variable "repo_webhook_active" {
  default = true
}

variable "repo_webhook_content_type" {
  default = "json"
}

variable "repo_webhook_insecure_ssl" {
  default = "false"
}

#--------------------------------------------------------------
# Collaborator Variables
#--------------------------------------------------------------
variable "pull_collaborators" {
  type    = "list"
  default = []
}

variable "push_collaborators" {
  type    = "list"
  default = []
}

variable "admin_collaborators" {
  type    = "list"
  default = []
}

#--------------------------------------------------------------
# Team Variables
#--------------------------------------------------------------
variable "pull_teams" {
  type    = "list"
  default = []
}

variable "push_teams" {
  type    = "list"
  default = []
}

variable "admin_teams" {
  type    = "list"
  default = []
}

#--------------------------------------------------------------
# Labels Variables
#--------------------------------------------------------------
variable "labels" {
  type    = "list"
  default = []
}

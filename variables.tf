#--------------------------------------------------------------
# Repo Variables
#--------------------------------------------------------------
variable "name" {}
variable "has_issues" { default = true}
variable "has_wiki" { default = true}
variable "allow_merge_commit" { default = false}
variable "allow_squash_commit" { default = true}
variable "allow_rebase_merge" { default = false}
variable "required_status_checks" { default = true}
variable "dismiss_stale_reviews" { default = true}
variable "private" { default = true}
variable "gitignore_template" { default = "Node"}
variable "protected_branches" { type = "list" default = ["master"]}

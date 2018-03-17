# terraform-github-repo

This module creates a GitHub repository with optional branch protections, deploy keys, webhooks, collaborators, teams, and labels.

## Usage

```hcl
module "test_repo" {
  source                   = "git::https://github.com/saf-scb/terraform-github_repo.git?ref=master"
  name                     = "test-repo"
  description              = "Repo for test code"
  private                  = false
  
  protected_branches_enabled = true
  protected_branches        = [
      {
        branch = "master"
        enforce_admins = true
      
        required_status_checks {
          strict = false
        }
      
        required_pull_request_reviews {
          dismiss_stale_reviews = true
        }
      },
      {
        branch = "develop"
      
        required_pull_request_reviews {
          dismiss_stale_reviews = false
          dismissal_users = ["engineer-user"] # admin-user (inherited from default) and engineer-user
          dismissal_teams = ["engineers"] # admins (inherited from default) and engineers
        }
      
        restrictions {
          users = ["engineer-user"] # admin-user and engineer-user
          teams = ["engineers"] # admins and engineers
        }
      }
  ]
  
  enforce_admins = false # default value

  required_status_checks_strict = true # default value
  required_status_checks_contexts = ["ci/travis"] # added to every branch protection

  dismiss_stale_reviews = true # default value
  dismissal_users = ["admin-user"] # added to every branch protection
  dismissal_teams = ["admins"] # added to every branch protection

  restriction_users = ["admin-user"] # added to every branch protection
  restriction_teams = ["admins"] #added to every branch protection
  
  deploy_key_enabled = true
  deploy_keys = [
    {
      "name" = "circle ci",
      "key" = "${file(~/.ssh/circleci_key)}"
      "read_only" = false
    },
    {
      "name" = "code_pipeline",
      "key" = "${file(~/.ssh/aws_codepipeline_key)}"
      "read_only" = true
    }
  ]
  
  repo_webhook_enabled = true
  repo_webhooks = [
    {
      "name" = "travis"
      "events" = ["push", "fork"]
      "url" = "https://api.test.com/github-hook-url1"
      "content_type" = "form"
      "active" = false
    },
    {
      "url" = "https://api.test.com/github-hook-url2"
      "active" = true
    }
  ]
  
  admin_teams = ["admins"]
  
  labels = [
    {
      "name" = "wip"
      "color" = "FFFFFF"
    },
    {
    "name" = "help"
    "color" = "00FF00"
    }
   ]
}
```


## Variables
|  Name                               |  Default                 |  Description                                                                                       | Required |
|:------------------------------------|:------------------------:|:---------------------------------------------------------------------------------------------------|:--------:|
| `name`                              | ``                       | Name  (e.g. `test_repo`)                                                                           | Yes      |
| `description`                       | ``                       | Description of repository  (e.g. `Repo for test code`)                                             | Yes      |
| `homepage_url`                      | `""`                     | URL of a page describing the project.                                                              | No       |
| `private`                           | `true`                   | Is the GitHub repo is private (true or false)                                                      | No       |
| `has_issues`                        | `true`                   | Does the GitHub repo have issues (true or false)                                                   | No       |
| `has_wiki`                          | `true`                   | Dose the GitHub repo have a wiki (true or false)                                                   | No       |
| `allow_merge_commit`                | `false`                  | Are merge commits allowed                                                                          | No       |
| `allow_squash_commit`               | `true`                   | Are squash commits allowed                                                                         | No       |
| `allow_rebase_commit`               | `false`                  | Are rebase commits allowed                                                                         | No       |
| `auto_init`                         | `false`                  | Init the repository with an initial commit                                                         | No       |
| `gitignore_template`                | `""`                     | .gitignore [template](gitignore template) to use with repository                                   | No       |
| `license_template`                  | `""`                     | license [template](license template) to use with repository                                        | No       |
| `protected_branches_enabled`        | `true`                   | Are branch protections enabled                                                                     | No       |
| `protected_branches`                | `[{branch = "master"}]`  | Array of maps declaring branch to protect and specific overrides                                   | No       |
| `enforce_admins`                    | `true`                   | Default value for enforce admins unless overriden by protected_branches                            | No       |
| `required_status_checks_strict`     | `false`                  | Default value for strict status checks unless overriden by protected_branches                      | No       |
| `required_status_checks_contexts`   | `[]`                     | Context which is applied to every branch in addition to override values                            | No       |
| `dismiss_stale_reviews`             | `false     `             | Default value for dismissing stale reviews unless overriden by protected_branches                  | No       |
| `dismissal_users`                   | `[]`                     | Users with dismissal access to every branch in addition to override values                         | No       |
| `dismissal_teams`                   | `[]`                     | Teams with dismissal access to every branch in addition to override values                         | No       |
| `require_code_owner_reviews`        | `true`                   | Default value for code owner reviews required                                                      | No       |
| `restriction_users`                 | `[]`                     | Users with push access to every branch in addition to override values                              | No       |
| `restriction_teams`                 | `[]`                     | Teams with push access to every branch in addition to override values                              | No       |
| `deploy_key_enabled`                | `false`                  | Are deploy keys used with this repository                                                          | No       |
| `deploy_keys`                       | `[]`                     | A list of deploy key map objects                                                                   | No       |
| `deploy_key`                        | `""`                     | SSH key to be used for deploy key                                                                  | No       |
| `deploy_key_read_only`              | `true`                   | Is the deploy key read only or read/write                                                          | No       |
| `repo_webhook_enabled`              | `false`                  | Are webhooks used with this repository                                                             | No       |
| `repo_webhooks`                     | `[]`                     | List of webhook maps (see below)                                                                   | No       |
| `repo_webhook_name`                 | `jenkins`                | Default name for webhooks [name](webhook names) unless overriden (see below)                       | No       |
| `repo_webhook_events`               | `["push"]`               | Default [events](webhook events) for webhooks unless overriden (see below)                         | No       |
| `repo_webhook_content_type`         | `"json"`                 | Default [content_type](content type) for webhooks unless overriden (see below)                     | No       |
| `repo_webhook_insecure_ssl`         | `false`                  | Default insecure ssl value unless overriden                                                        | No       |
| `repo_webhook_configuration`        | `{}`                     | Default webhook configuration value unless overriden                                               | No       |
| `repo_webhook_active`               | `true`                   | Default value if webhook is active unless overriden                                                | No       |
| `pull_collaborators`                | `[]`                     | List of users with pull access                                                                     | No       |
| `push_collaborators`                | `[]`                     | List of users with push access                                                                     | No       |
| `admin_collaborators`               | `[]`                     | List of users with admin access                                                                    | No       |
| `pull_teams`                        | `[]`                     | List of teams with pull access                                                                     | No       |
| `push_teams`                        | `[]`                     | List of teams with push access                                                                     | No       |
| `admin_teams`                       | `[]`                     | List of teams with admin access                                                                    | No       |
| `labels`                            | `[]     `                | List of label maps (see below)                                                                     | No       |


## Branch Protection Overrides
|  Name                               |  Default                                 |  Description                                                         | Required |
|:------------------------------------|:----------------------------------------:|:---------------------------------------------------------------------|:--------:|
| `branch`                            | ``                                       | Branch to protect  (e.g. `master`)                                   | Yes      |
| `enforce_admins`                    | `module.enforce_admins`                  | Enforce admins (true or false)                                       | No       |
| `required_status_checks_strict`     | `module.required_status_checks_strict`   | Does the branch need to be up-to-date before merging                 | No       |
| `required_status_checks_contexts`   | `[]`                                     | List of names of status check which must pass before merging         | No       |
| `dismiss_stale_reviews`             | `module.dismiss_stale_reviews`           | Dismiss reviews if new changes pushed to branch                      | No       |
| `dismissal_users`                   | `[]`                                     | Users with the ability to dismiss reviews branch                     | No       |
| `dismissal_teams`                   | `[]`                                     | the ability to dismiss reviews                            | No       |
| `require_code_owner_reviews`        | `module.require_code_owner_reviews`      | Require reviews according .github/CODEOWNERS                         | No       |
| `restriction_users`                 | `[]`                                     | Users with restricted push access                                    | No       |
| `restriction_teams`                 | `[]`                                     | teams with restricted push access                                    | No       |

## Deploy Keys
|  Name                               |  Default                        |  Description                                             | Required |
|:------------------------------------|:-------------------------------:|:---------------------------------------------------------|:--------:|
| `name`                              | ``                              | Name of key    (e.g. `circleci`)                         | Yes      |
| `key`                               | `module.deploy_key`             | Path to key    (e.g. `${file(~/.ssh/id_rsa.pub)}`)       | No       |
| `read_only`                         | `module.deploy_key_read_only`   | Key is read only                                         | No       |

## Webhooks
|  Name                               |  Default                             |  Description                                             | Required |
|:------------------------------------|:------------------------------------:|:---------------------------------------------------------|:--------:|
| `name`                              | ``                                   | Name of key    (e.g. `circleci`)                         | Yes      |
| `key`                               | `module.deploy_key`                  | Path to key    (e.g. `${file(~/.ssh/id_rsa.pub)}`)       | No       |
| `read_only`                         | `module.deploy_key_read_only`        | Key is read only                                         | No       |
| `events`                            | `module.repo_webhooks_events`        | Events for the webhook to publish                        | No       |
| `configuration_keys`                | `""`                                 | Space separated list of custom configuration keys        | No       |
| `configuration_values`              | `""`                                 | Space separated list of custom configuration values      | No       |

## Labels
|  Name                               |  Default                 |  Description                                                    | Required |
|:------------------------------------|:------------------------:|:----------------------------------------------------------------|:--------:|
| `name`                              | ``                       | Name of label  (e.g. `wip`)                                     | Yes      |
| `color`                             | ``                       | Color of label (e.g. `FF0000`)                                  | Yes      |
## Outputs

| Name                  | Description                           |
|:----------------------|:--------------------------------------|
| `name`                | Name of repo                          |
| `webhook_urls`        | URLs of webhooks                      |



## Help

**Got a question?**

File a GitHub [issue](https://github.com/saf-scb/terraform-github-repo/issues), send us an [email](mailto:gabel0287@gmail.com).


## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/saf-scb/terraform-github-repo/isues) to report any bugs or file feature requests.

## License

[APACHE 2.0](LICENSE) © 2018 [saf-scb, LLC](https://license2scale.com)

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.



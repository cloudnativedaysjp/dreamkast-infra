data "tfe_organization" "org" {
  name = "kusama"
}

data "tfe_team" "cloudnativedays" {
  name         = "cloudnativedays"
  organization = "kusama"
}

variable "oauth_token_id" {
  default = "ot-TXWpAfuW6HpR3aCT"
}

resource "tfe_workspace" "nextcloud" {
  name                = "nextcloud"
  organization        = data.tfe_organization.org.name
  auto_apply          = false
  queue_all_runs      = false
  speculative_enabled = false
  working_directory   = "terraform/nextcloud"
  execution_mode = "remote"
  vcs_repo {
    identifier         = "cloudnativedaysjp/dreamkast-infra"
    ingress_submodules = false
    oauth_token_id     = var.oauth_token_id
  }
}

resource "tfe_team_access" "nextcloud" {
  access       = "admin"
  team_id      = data.tfe_team.cloudnativedays.id
  workspace_id = tfe_workspace.nextcloud.id
}

resource "tfe_workspace" "github" {
  name                = "github"
  organization        = data.tfe_organization.org.name
  auto_apply          = false
  queue_all_runs      = false
  speculative_enabled = false
  working_directory   = "terraform/github"
  execution_mode = "remote"
  vcs_repo {
    identifier         = "cloudnativedaysjp/dreamkast-infra"
    ingress_submodules = false
    oauth_token_id     = var.oauth_token_id
  }
}

resource "tfe_team_access" "github" {
  access       = "admin"
  team_id      = data.tfe_team.cloudnativedays.id
  workspace_id = tfe_workspace.github.id
}


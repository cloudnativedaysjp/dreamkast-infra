data "tfe_organization" "org" {
  name = "kusama"
}

variable "oauth_token_id" {
  default = "ot-dF6Fozb1a8o8NXq8"
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

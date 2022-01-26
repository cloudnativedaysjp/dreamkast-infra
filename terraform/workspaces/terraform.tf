terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "kusama"

    workspaces {
      name = "workspaces"
    }
  }
}
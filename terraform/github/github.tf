provider "github" {
    owner = "cloudnativedaysjp"
}

resource "github_repository" "observability2021" {
  name        = "observability2021"
  description = "observability2021に関わるあれこれを管理していくリポジトリ"

  visibility = "private"
  has_issues = true
  has_projects = false
  has_wiki = false
  auto_init = true
  archive_on_destroy = true
  vulnerability_alerts = false
}

resource "github_repository" "cndt2021" {
  name        = "cndt2021"
  description = "CNDT2021に関わるあれこれを管理していくリポジトリ"

  visibility = "private"
  has_issues = true
  has_projects = true
  has_wiki = true
  auto_init = false
  archive_on_destroy = true
  vulnerability_alerts = false
}

resource "github_membership" "membership_for_admin" {
  for_each = toset( ["jacopen"] )
  username = each.key
  role     = "admin"
}

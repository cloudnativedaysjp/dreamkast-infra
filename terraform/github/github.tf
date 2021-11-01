provider "github" {}

resource "github_repository" "observability2021" {
  name        = "cloudnativedaysjp/observability2021"
  description = "observability2021に関わるあれこれを管理していくリポジトリ"

  visibility = "private"
  has_issues = true
  has_projects = false
  has_wiki = false
  auto_init = true
  archive_on_destroy = true
  vulnerability_alerts = false
}

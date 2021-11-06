provider "github" {
  owner = "cloudnativedaysjp"
}

resource "github_repository" "observability2021" {
  name        = "observability2021"
  description = "observability2021に関わるあれこれを管理していくリポジトリ"

  visibility           = "private"
  has_issues           = true
  has_projects         = false
  has_wiki             = false
  auto_init            = true
  archive_on_destroy   = true
  vulnerability_alerts = false
}

resource "github_repository" "cndt2021" {
  name        = "cndt2021"
  description = "CNDT2021に関わるあれこれを管理していくリポジトリ"

  visibility           = "private"
  has_issues           = true
  has_projects         = true
  has_wiki             = true
  auto_init            = false
  archive_on_destroy   = true
  vulnerability_alerts = false
}

resource "github_membership" "membership_for_admin" {
  for_each = toset(["jacopen", "Fufuhu", "inductor", "jyoshise", "kojiha", "kyohmizu", "makocchi-git", "MasayaAoyama", "nabemasat", "ShotaKitazawa", "showks-containerdaysjp", "suzukin", "takaishi", "tsukaman", "zembutsu"])
  username = each.key
  role     = "admin"
}

resource "github_membership" "membership_for_member" {
  for_each = toset(["capsmalt", "chago0419", "cyberblack28", "Gaku-Kunimi", "guni1192", "iaoiui", "ito-taka", "kaedemalu", "KaseiKondo", "kntks", "maktak1995", "naka-teruhisa", "nnao45", "oke-py", "oshiro3", "ryojsb", "ryoryotaro", "TakumaNakagame", "TakumaNakagame", "yassan", "Yoshiki0705"])
  username = each.key
  role     = "member"
}

resource "github_team" "broadcasting" {
  name = "broadcasting"
  privacy = "closed"
}

resource "github_team" "chairs" {
  name = "chairs"
  privacy = "closed"
}

resource "github_team" "cicd_handson" {
  name = "cicd-handson"
  privacy = "closed"
}

resource "github_team" "cndt2021" {
  name = "cndt2021"
  privacy = "closed"
}

resource "github_team" "dreamkast" {
  name = "dreamkast"
  privacy = "closed"
}

resource "github_team" "dreamkast_admin" {
  name = "dreamkast_admin"
  privacy = "closed"
}

resource "github_team" "dreamkast_admin" {
  name = "dreamkast_admin"
  privacy = "closed"
}

resource "github_team" "o11y2022" {
  name = "Observability2022"
  privacy = "closed"
}

data "sakuracloud_archive" "ubuntu" {
  filter {
    id = "113301413483"
  }
}
data "sakuracloud_archive" "ubuntu2204" {
  filter {
    id = "113401132828"
  }
}
data "sakuracloud_archive" "windows" {
  filter {
    id = "113401184142"
  }
}

# data "http" "key" {
#   for_each = toset( ["jacopen", "TakumaNakagame"] )
#   url = "https://github.com/${each.key}.keys"
# }

data "github_user" "jacopen" {
  username = "jacopen"
}

resource "sakuracloud_ssh_key" "key" {
  for_each   = toset(data.github_user.jacopen.ssh_keys)
  name       = "sshkey-${index(data.github_user.jacopen.ssh_keys, each.key)}"
  public_key = each.value
}

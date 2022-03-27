terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "kusama"
    workspaces {
      name = "broadcast_switcher"
    }
  }
  required_providers {
    sakuracloud = {
      source  = "sacloud/sakuracloud"
      version = "~> 2.16.2"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
provider "sakuracloud" {
}

provider "aws" {
}
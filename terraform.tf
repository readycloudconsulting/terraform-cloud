terraform {
  backend "remote" {
    organization = "ready-cloud-consulting"
    workspaces {
      name = "terraform-cloud"
    }
  }
  required_version = "~> 1.0"
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.31"
    }
  }
}

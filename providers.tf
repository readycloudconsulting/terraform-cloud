provider "tfe" {
  hostname = "app.terraform.io"
}

provider "github" {
  token        = var.github_oauth_token
  organization = "readycloudconsulting"
}

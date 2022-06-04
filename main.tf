resource "tfe_organization" "this" {
  name  = "ready-cloud-consulting"
  email = "jared@readycloudconsulting.com"
}

resource "tfe_oauth_client" "this" {
  name         = "github"
  organization = tfe_organization.this.name

  service_provider = "github"
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.github_oauth_token
}

locals {
  workspaces = {
    terraform-cloud = {
      description = "Terraform Cloud organization and workspaces"
      vcs_settings = {
        visibility = "public"
      }
    }
    marketing-site = {
      description = "readycloudconsulting.com marketing site infrastructure"
    }
    core-infrastructure = {
      description = "Core infrastucture shared across all properties"
    }
  }
}

resource "tfe_workspace" "this" {
  for_each = local.workspaces

  name                  = each.key
  description           = try(each.value.description, null)
  organization          = tfe_organization.this.name
  file_triggers_enabled = false

  vcs_repo {
    identifier     = github_repository.this[each.key].full_name
    branch         = "main"
    oauth_token_id = tfe_oauth_client.this.oauth_token_id
  }
}

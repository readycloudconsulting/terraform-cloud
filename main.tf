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
      vcs_repo = {
        identifier = "readycloudconsulting/terraform-cloud"
        branch     = "main"
      }
    }
  }
}

resource "tfe_workspace" "this" {
  for_each = local.workspaces

  name                  = each.key
  description           = try(each.key.description, null)
  organization          = tfe_organization.this.name
  file_triggers_enabled = false

  dynamic "vcs_repo" {
    for_each = [each.value.vcs_repo]

    content {
      identifier     = vcs_repo.value.identifier
      branch         = vcs_repo.value.branch
      oauth_token_id = tfe_oauth_client.this.oauth_token_id
    }
  }
}

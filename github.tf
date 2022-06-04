data "github_organization" "this" {
  name = "readycloudconsulting"
}

resource "github_repository" "this" {
  for_each = local.workspaces

  name               = "readycloudconsulting/${each.key}"
  description        = try(each.value.description, null)
  visibility         = private
  gitignore_template = "Terraform"
}

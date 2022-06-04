resource "github_repository" "this" {
  for_each = local.workspaces

  name               = each.key
  description        = try(each.value.description, null)
  visibility         = "private"
  gitignore_template = "Terraform"
}

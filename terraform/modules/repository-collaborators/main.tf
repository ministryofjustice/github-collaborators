resource "github_repository_collaborator" "collaborator" {
  repository = var.repository
  for_each   = var.collaborators
  username   = each.key
  permission = each.value
}

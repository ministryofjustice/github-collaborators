resource "github_repository_collaborator" "collaborator" {
  repository = var.repository
  for_each   = { for collab in var.collaborators : collab.github_user => collab }
  username   = each.value.github_user
  permission = each.value.permission
}

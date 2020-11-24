variable "repository" {
  type        = string
  description = "Repository name (without owner)"
}

variable "collaborators" {
  type        = map
  description = "github_user:permission map for repository external collaborators"
  default     = {}
}

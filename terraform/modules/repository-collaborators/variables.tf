variable "repository" {
  type        = string
  description = "Repository name (without owner)"
}

variable "collaborators" {
  description = "Details of all the external collaborators of a repository"
  type = list(object({
    github_user  = string
    permission   = string
    name         = string
    email        = string
    org          = string
    reason       = string
    added_by     = string
    review_after = string
  }))
  default = [
    {
      github_user  = ""
      permission   = ""
      name         = ""
      email        = ""
      org          = ""
      reason       = ""
      added_by     = ""
      review_after = ""
    }
  ]
}

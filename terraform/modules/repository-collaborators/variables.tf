variable "repository" {
  type        = string
  description = "Repository name (without owner)"
}

variable "collaborators" {
  description = "Details of all the outside collaborators of a repository"
  type = list(object({
    github_user  = string #  The github_user who needs to access the repository
    permission   = string #  The level of access: pull|push|admin
    name         = string #  The name of the person behind github_user
    email        = string #  Their email address
    org          = string #  The organisation/entity they belong to
    reason       = string #  Why is this person being granted access?
    added_by     = string #  Who made the decision to grant them access? e.g. "Some Person <some.person@digital.justice.gov.uk>"
    review_after = string #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
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

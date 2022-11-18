module "acronyms" {
  source     = "./modules/repository-collaborators"
  repository = "acronyms"
  collaborators = [
    {
      github_user  = "matthewtansini"
      permission   = "push"
      name         = ""
      email        = ""
      org          = ""
      reason       = ""
      added_by     = ""
      review_after = ""
    },
  ]
}
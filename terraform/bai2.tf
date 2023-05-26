module "bai2" {
  source     = "./modules/repository-collaborators"
  repository = "bai2"
  collaborators = [
    {
      github_user  = "ibredfds32423chin"
      permission   = "admin"
      name         = "Ian Brechin"
      email        = "ian.brechin@gmail.com"
      org          = "External, formerly on Prisoner Money team"
      reason       = "To maintain open-source Python libraries used by MoJ and externally"
      added_by     = "igor.ushkarev@digital.justice.gov.uk"
      review_after = "2024-04-18"
    },
  ]
}

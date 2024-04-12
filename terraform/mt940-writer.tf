module "mt940-writer" {
  source     = "./modules/repository-collaborators"
  repository = "mt940-writer"
  collaborators = [
    {
      github_user  = "ibrechin"
      permission   = "push"
      name         = "Ian Brechin"
      email        = "ian.brechin@gmail.com"
      org          = "External, formerly on Prisoner Money team"
      reason       = "To maintain open-source Python libraries used by MoJ and externally"
      added_by     = "igor.ushkarev@digital.justice.gov.uk"
      review_after = "2024-10-15"
    },
  ]
}

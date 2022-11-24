module "hmpps-domestic-abuse-support-officers" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-domestic-abuse-support-officers"
  collaborators = [
    {
      github_user  = "miriamgo-civica"
      permission   = "push"
      name         = "Miriam Gomez-Orozco"
      email        = "Miriam.Gomez-Orozco@civica.co.uk"
      org          = "Civica"
      reason       = "Civica developer for DASO"
      added_by     = "Probation Infrastructure AWS Team, awssupportteam@digital.justice.gov.uk"
      review_after = "2023-02-27"
    },
    {
      github_user  = "sim-barnes"
      permission   = "push"
      name         = "Simon Barnes"
      email        = "simon.barnes@civica.co.uk"
      org          = "Civica"
      reason       = "Civica developer for DASO"
      added_by     = "Probation Infrastructure AWS Team, awssupportteam@digital.justice.gov.uk"
      review_after = "2023-12-20"
    },
    {
      github_user  = "CodeSureUK"
      permission   = "maintain"
      name         = "Toby Liddicoat"
      email        = "toby.liddicoat@civica.co.uk"
      org          = "Civica"
      reason       = "Civica developer for DASO"
      added_by     = "Probation Infrastructure AWS Team, awssupportteam@digital.justice.gov.uk"
      review_after = "2023-03-31"
    },
    {
      github_user  = "shaunthornburgh"
      permission   = "push"
      name         = "Shaun Thornburgh"
      email        = "shaun.thornburgh@civica.co.uk"
      org          = "Civica"
      reason       = "Civica developer for DASO"
      added_by     = "Probation Infrastructure AWS Team, awssupportteam@digital.justice.gov.uk"
      review_after = "2023-04-30"
    },
  ]
}

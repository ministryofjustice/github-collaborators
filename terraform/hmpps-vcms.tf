module "hmpps-vcms" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-vcms"
  collaborators = [
    {
      github_user  = "simoncreasy-civica"
      permission   = "push"
      name         = "Simon Creasy"
      email        = "simon.creasy@civica.co.uk"
      org          = "Civica"
      reason       = "Civica developer that helps the development of the Victims Case Management System"
      added_by     = "Probation Infrastructure AWS Team, awssupportteam@digital.justice.gov.uk"
      review_after = "2022-11-21"
    },
    {
      github_user  = "miriamgo-civica"
      permission   = "maintain"
      name         = "Miriam Gomez-Orozco"
      email        = "Miriam.Gomez-Orozco@civica.co.uk"
      org          = "Civica"
      reason       = "Civica developer for Victims Case Management System"
      added_by     = "Probation Infrastructure AWS Team, maximillian.lakanu@digital.justice.gov.uk"
      review_after = "2023-02-27"
    },
    {
      github_user  = "sim-barnes"
      permission   = "maintain"
      name         = "Simon Barnes"
      email        = "simon.barnes@civica.co.uk"
      org          = "Civica"
      reason       = "Civica developer for Victims Case Management System"
      added_by     = "Probation Infrastructure AWS Team, maximillian.lakanu@digital.justice.gov.uk"
      review_after = "2022-12-27"
    },
    {
      github_user  = "CodeSureUK"
      permission   = "maintain"
      name         = "Toby Liddicoat"
      email        = "toby.liddicoat@civica.co.uk"
      org          = "Civica"
      reason       = "Civica developer for Victims Case Management System"
      added_by     = "Probation Infrastructure AWS Team, maximillian.lakanu@digital.justice.gov.uk"
      review_after = "2023-03-31"
    },
  ]
}

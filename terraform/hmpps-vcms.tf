module "hmpps-vcms" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-vcms"
  collaborators = [
    {
      github_user  = "miriamgo-civica"
      permission   = "push"
      name         = "Miriam Gomez-Orozco"
      email        = "Miriam.Gomez-Orozco@civica.co.uk"
      org          = "Civica"
      reason       = "Civica developer for Victims Case Management System"
      added_by     = "Probation Infrastructure AWS Team, maximillian.lakanu@digital.justice.gov.uk"
      review_after = "2023-05-27"
    },
    {
      github_user  = "sim-barnes"
      permission   = "push"
      name         = "Simon Barnes"
      email        = "simon.barnes@civica.co.uk"
      org          = "Civica"
      reason       = "Civica developer for Victims Case Management System"
      added_by     = "Probation Infrastructure AWS Team, maximillian.lakanu@digital.justice.gov.uk"
      review_after = "2023-12-20"
    },
    {
      github_user  = "codesureuk"
      permission   = "maintain"
      name         = "Toby Liddicoat"
      email        = "toby.liddicoat@civica.co.uk"
      org          = "Civica"
      reason       = "Civica developer for Victims Case Management System"
      added_by     = "Probation Infrastructure AWS Team, maximillian.lakanu@digital.justice.gov.uk"
      review_after = "2023-09-27"
    },
    {
      github_user  = "simoncreasy-civica"
      permission   = "push"
      name         = "Simon Creasy"
      email        = "simon.creasy@civica.co.uk"
      org          = "civica"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-08-21"
    },
  ]
}

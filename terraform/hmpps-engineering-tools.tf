module "hmpps-engineering-tools" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-engineering-tools"
  collaborators = [
    {
      github_user  = "simoncreasy-civica"
      permission   = "push"
      name         = "Simon Creasy"
      email        = "simon.creasy@civica.co.uk"
      org          = "civica"
      reason       = "HMPPS related work"
      added_by     = "Vincent Cheung <vincent.cheung@digital.justice.gov.uk>"
      review_after = "2023-12-20"
    },
    {
      github_user  = "sim-barnes"
      permission   = "push"
      name         = "Simon Barnes"
      email        = "simon.barnes@civica.co.uk"
      org          = "civica"
      reason       = "HMPPS related work"
      added_by     = "Vincent Cheung <vincent.cheung@digital.justice.gov.uk>"
      review_after = "2023-12-20"
    },
    {
      github_user  = "miriamgo-civica"
      permission   = "push"
      name         = "Miriam Gomez-Orozco"
      email        = "Miriam.Gomez-Orozco@civica.co.uk"
      org          = "civica"
      reason       = "HMPPS related work"
      added_by     = "Vincent Cheung <vincent.cheung@digital.justice.gov.uk>"
      review_after = "2023-12-20"
    },
    {
      github_user  = "nick"
      permission   = "admin"
      name         = "nick walters"
      email        = "nick.walter@justice.gov.uk"
      org          = "moj"
      reason       = "test"
      added_by     = "nick ben.ashton@digital.justice.gov.uk"
      review_after = "2023-10-10"
    },
  ]
}

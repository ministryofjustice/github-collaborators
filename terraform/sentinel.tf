module "sentinel" {
  source     = "./modules/repository-collaborators"
  repository = "sentinel"
  collaborators = [
    {
      github_user  = "miriamgo-civica"
      permission   = "push"
      name         = "Miriam Gomez-Orozco"
      email        = "Miriam.Gomez-Orozco@civica.co.uk"
      org          = "Civica"
      reason       = "Access required as a supporting tool for VCMS"
      added_by     = "Antony Bishop antony.bishop@digital.justice.gov.uk"
      review_after = "2023-02-27"
    },
    {
      github_user  = "sim-barnes"
      permission   = "push"
      name         = "Simon Barnes"
      email        = "simon.barnes@civica.co.uk"
      org          = "Civica"
      reason       = "Access required as a supporting tool for VCMS"
      added_by     = "Antony Bishop antony.bishop@digital.justice.gov.uk"
      review_after = "2023-12-20"
    },
    {
      github_user  = "simoncreasy-civica"
      permission   = "push"
      name         = "Simon Creasy"
      email        = "simon.creasy@civica.co.uk"
      org          = "civica"
      reason       = "Access required as a supporting tool for VCMS"
      added_by     = "Antony Bishop antony.bishop@digital.justice.gov.uk"
      review_after = "2023-02-22"
    },
  ]
}

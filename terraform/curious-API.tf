module "curious-API" {
  source     = "./modules/repository-collaborators"
  repository = "curious-API"
  collaborators = [
    {
      github_user  = "vinishgeorge"
      permission   = "push"
      name         = "Vinish George"
      email        = "vinish.george@meganexus.com"
      org          = "MegaNexus"
      reason       = "MegaNexus are developing an API into Curious for HMPPS Education, Skills, Work and Employability (ESWE) project"
      added_by     = "Richard Adams <richard.adams@digital.justice.gov.uk>"
      review_after = "2022-10-05"
    },
    {
      github_user  = "punjraj-singh"
      permission   = "push"
      name         = "Punraj Singh"
      email        = "punraj.singh@meganexus.com"
      org          = "MegaNexus"
      reason       = "MegaNexus are developing an API into Curious for HMPPS Education, Skills, Work and Employability (ESWE) project"
      added_by     = "Richard Adams <richard.adams@digital.justice.gov.uk>"
      review_after = "2022-10-05"
    },
  ]
}

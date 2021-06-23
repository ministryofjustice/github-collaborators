module "curious-API" {
  source     = "./modules/repository-collaborators"
  repository = "curious-API"
  collaborators = [
    {
      github_user  = "graadi"
      permission   = "write"
      name         = "Adrian Gramada"
      email        = "adrian.gramada@meganexus.com"
      org          = "MegaNexus"
      reason       = "MegaNexus are developing an API into Curious for HMPPS Education, Skills, Work and Employability (ESWE) project"
      added_by     = "Richard Adams <richard.adams@digital.justice.gov.uk>"
      review_after = "2021-12-26"
    },
  ]
}

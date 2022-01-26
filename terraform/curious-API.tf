module "curious-API" {
  source     = "./modules/repository-collaborators"
  repository = "curious-API"
  collaborators = [
    {
      github_user  = "bharaatt"
      permission   = "push"
      name         = "Bharat Parmar"
      email        = "bharat.parmar@meganexus.com"
      org          = "MegaNexus"
      reason       = "MegaNexus are developing an API into Curious for HMPPS Education, Skills, Work and Employability (ESWE) project"
      added_by     = "Richard Adams <richard.adams@digital.justice.gov.uk>"
      review_after = "2022-06-18"
    },
  ]
}

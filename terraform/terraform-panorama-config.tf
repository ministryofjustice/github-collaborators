module "terraform-panorama-config" {
  source     = "./modules/repository-collaborators"
  repository = "terraform-panorama-config"
  collaborators = [
    {
      github_user  = "nmatveev"
      permission   = "push"
      name         = "Nikolay Matveev"
      email        = "nmatveev@paloaltonetworks.com"
      org          = "Palo Alto"
      reason       = "TechOps Management of Panorama"
      added_by     = "MoJ-TechnicalOperations@justice.gov.uk"
      review_after = "2022-03-31"
    },
  ]
}

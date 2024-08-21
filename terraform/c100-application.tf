module "c100-application" {
  source     = "./modules/repository-collaborators"
  repository = "c100-application"
  collaborators = [
    {
      github_user  = "sgmselli"
      permission   = "push"
      name         = "Matthew Sellings"
      email        = "Matthew.Sellings@HMCTS.NET"
      org          = "Solirius"
      reason       = "For work on the c100 application"
      added_by     = "avi.singh@justice.gov.uk"
      review_after = "2024-11-30"
    },
    {
      github_user  = "DanielleKushnir"
      permission   = "push"
      name         = "Danielle Kushnir"
      email        = "Danielle.Kushnir@HMCTS.NET"
      org          = "Solirius"
      reason       = "For work on the c100 application"
      added_by     = "avi.singh@justice.gov.uk"
      review_after = "2024-11-30"
    }
  ]
}

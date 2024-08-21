module "c100-application" {
  source     = "./modules/repository-collaborators"
  repository = "c100-application"
  collaborators = [
    {
      github_user  = "sgmselli"
      permission   = "push"
      name         = "Matthew Sellings"
      email        = "Matthew.Sellings@HMCTS.NET"
      org          = "HMCTS"
      reason       = "Application Developer"
      added_by     = "kalvin.lyu@hmcts.net"
      review_after = "2024-11-30"
    },
    {
      github_user  = "DanielleKushnir"
      permission   = "push"
      name         = "Danielle Kushnir"
      email        = "Danielle.Kushnir@HMCTS.NET"
      org          = "HMCTS"
      reason       = "Application Developer"
      added_by     = "kalvin.lyu@hmcts.net"
      review_after = "2024-11-30"
    },
  ]
}

module "hmpps-approved-premises-ui" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-approved-premises-ui"
  collaborators = [
    {
      github_user  = "GregJenkinsNCC"
      permission   = "pull"
      name         = "Greg Jenkins"
      email        = "greg.jenkins@nccgroup.com"
      org          = "NCC"
      reason       = "Pen. tester"
      added_by     = "Ed Davey <ed.davey@digital.justice.gov.uk>"
      review_after = "2023-02-28"
    }
  ]
}

module "hmpps-approved-premises-api" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-approved-premises-api"
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
    },
    {
      github_user  = "rr-ncc"
      permission   = "pull"
      name         = "Robert Ray"
      email        = "robert.ray@nccgroup.com"
      org          = "NCC"
      reason       = "Pen. tester"
      added_by     = "Ed Davey <ed.davey@digital.justice.gov.uk>"
      review_after = "2023-02-28"
    },
    {
      github_user  = "JonnyOrrNCC"
      permission   = "pull"
      name         = "Jonny Orr"
      email        = "jonny.orr@nccgroup.com"
      org          = "NCC"
      reason       = "Pen. tester"
      added_by     = "Ed Davey <ed.davey@digital.justice.gov.uk>"
      review_after = "2023-02-28"
    },
    {
      github_user  = "ThomasWellsNCC"
      permission   = "pull"
      name         = "Thomas Wells"
      email        = "thomas.wells@nccgroup.com"
      org          = "NCC"
      reason       = "Pen. tester"
      added_by     = "Ed Davey <ed.davey@digital.justice.gov.uk>"
      review_after = "2023-02-28"
    }
  ]
}

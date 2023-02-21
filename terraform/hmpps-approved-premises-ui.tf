module "hmpps-approved-premises-ui" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-approved-premises-ui"
  collaborators = [
    {
      github_user  = "gregjenkinsncc"
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
      github_user  = "jonnyorrncc"
      permission   = "pull"
      name         = "Jonny Orr"
      email        = "jonny.orr@nccgroup.com"
      org          = "NCC"
      reason       = "Pen. tester"
      added_by     = "Ed Davey <ed.davey@digital.justice.gov.uk>"
      review_after = "2023-02-28"
    },
    {
      github_user  = "thomaswellsncc"
      permission   = "pull"
      name         = "Thomas Wells"
      email        = "thomas.wells@nccgroup.com"
      org          = "NCC"
      reason       = "Pen. tester"
      added_by     = "Ed Davey <ed.davey@digital.justice.gov.uk>"
      review_after = "2023-02-28"
    },
    {
      github_user  = "emileswarts"
      permission   = "push"
      name         = "emile swarts"
      email        = "emile@madetech.com"
      org          = "made tech ltd"
      reason       = "Full Org member / collaborator missing from Terraform file"
      added_by     = "opseng-bot@digital.justice.gov.uk"
      review_after = "2023-05-22"
    },
  ]
}

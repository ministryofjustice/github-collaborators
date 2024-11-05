module "pfl-parent-planner" {
  source     = "./modules/repository-collaborators"
  repository = "pfl-parent-planner"
  collaborators = [
    {
      github_user  = "StuBamforthDWP"
      permission   = "push"
      name         = "Stuart Bamforth"
      email        = "stu.bamforth@guest.vivace.tech"
      org          = "Wyser via the Ace platform"
      reason       = "Prototype creation for a new service"
      added_by     = "Chris.Anderson1@justice.gov.uk"
      review_after = "2024-12-31"
    },
  ]
}

module "staff-device-management-virtualdesktop" {
  source     = "./modules/repository-collaborators"
  repository = "staff-device-management-virtualdesktop"
  collaborators = [
    {
      github_user  = "NickyScout"
      permission   = "push"
      name         = "Nikolay Milyaev"
      email        = "nmilyaev@microsoft.com"
      org          = "Microsoft"
      reason       = "MoJO AVD build into a Microsoft Windows 365 product"
      added_by     = "leanne.emans@justice.gov.uk"
      review_after = "2024-12-01"
    },
  ]
}

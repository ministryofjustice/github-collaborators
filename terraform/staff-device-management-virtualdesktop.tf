module "staff-device-management-virtualdesktop" {
  source     = "./modules/repository-collaborators"
  repository = "staff-device-management-virtualdesktop"
  collaborators = [
    {
      github_user  = ""
      permission   = "push"
      name         = "Catrina Feely"
      email        = "cfeely@microsoft.com"
      org          = "Microsoft"
      reason       = "MoJO AVD build into a Microsoft Windows 365 product"
      added_by     = "Leanne.Emans@justice.gov.uk"
      review_after = "2024-12-01"
    },
    {
      github_user  = ""
      permission   = "push"
      name         = "Renu Sandy"
      email        = "resandy@microsoft.com"
      org          = "Microsoft"
      reason       = "MoJO AVD build into a Microsoft Windows 365 product"
      added_by     = "Leanne.Emans@justice.gov.uk"
      review_after = "2024-12-01"
    },
    {
      github_user  = ""
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

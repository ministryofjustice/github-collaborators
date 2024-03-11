module "cjse-test" {
  source     = "./modules/repository-collaborators"
  repository = "cjse-test"
  collaborators = [
    {
      github_user  = "jbantrotu"
      permission   = "admin"
      name         = "Jagadeesh Bantrotu"
      email        = "jagadeesh.bantrotu@version1.com"
      org          = "Version 1"
      reason       = "Get access to xhibit-portal on Cloud Platform"
      added_by     = "shahzad.chaudhry@digital.justice.gov.uk"
      review_after = "2024-08-01"
    },
    {
      github_user  = "raydevlinv1"
      permission   = "admin"
      name         = "Ray Devlin"
      email        = "ray.devlin@version1.com"
      org          = "Version 1"
      reason       = "Get access to xhibit-portal on Cloud Platform"
      added_by     = "shahzad.chaudhry@digital.justice.gov.uk"
      review_after = "2024-08-01"
    },
    {
      github_user  = "Klaw29"
      permission   = "admin"
      name         = "Kay Babatunde"
      email        = "kbabatunde@planittesting.com"
      org          = "Version 1"
      reason       = "Get access to xhibit-portal on Cloud Platform"
      added_by     = "shahzad.chaudhry@digital.justice.gov.uk"
      review_after = "2024-08-01"
    },
    {
      github_user  = "mdestani"
      permission   = "admin"
      name         = "Mond Destani"
      email        = "mdestani@planittesting.com"
      org          = "Version 1"
      reason       = "Get access to xhibit-portal on Cloud Platform"
      added_by     = "shahzad.chaudhry@digital.justice.gov.uk"
      review_after = "2024-08-01"
    },
    {
      github_user  = "BertONeill-V1"
      permission   = "admin"
      name         = "Bert O'Neill"
      email        = "bert.oneill@version1.com"
      org          = "Version 1"
      reason       = "Get access to xhibit-portal on Cloud Platform"
      added_by     = "shahzad.chaudhry@digital.justice.gov.uk"
      review_after = "2024-08-01"
    },
  ]
}
module "hmpps-integration-api" {
  source     = "./modules/repository-collaborators"
  repository = "hmpps-integration-api"
  collaborators = [
    {
      github_user  = "emileswarts"
      permission   = "admin"
      name         = "Emile Swarts"
      email        = "emile.swarts@digital.justice.gov.uk"
      org          = "Made Tech"
      reason       = "Managed service provider for the new HMPPS Integration API"
      added_by     = "Martin Ballhatchet <martin.ballhatchet@digital.justice.gov.uk>"
      review_after = "2024-01-01"
    },
    {
      github_user  = "chubberlisk"
      permission   = "admin"
      name         = "Wen Ting Wang"
      email        = "wen.tingwang@digital.justice.gov.uk"
      org          = "Made Tech"
      reason       = "Managed service provider for the new HMPPS Integration API"
      added_by     = "Martin Ballhatchet <martin.ballhatchet@digital.justice.gov.uk>"
      review_after = "2024-01-01"
    },
    {
      github_user  = "aprilmd"
      permission   = "admin"
      name         = "April Dawson"
      email        = "April.Dawson@digital.justice.gov.uk"
      org          = "Made Tech"
      reason       = "Managed service provider for the new HMPPS Integration API"
      added_by     = "Martin Ballhatchet <martin.ballhatchet@digital.justice.gov.uk>"
      review_after = "2024-01-01"
    },
  ]
}

module "yjaf-serious-incidents" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-serious-incidents"
  collaborators = [
    {
      github_user  = "gregi2n"
      permission   = "admin"
      name         = "Greg Whiting"
      email        = "greg.whiting@northgateps.com"
      org          = "NEC"
      reason       = "Access is needed for development of a new feature for yjaf"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2023-05-25"
    },
    {
      github_user  = "javaidarshadnec"
      permission   = "admin"
      name         = "Javaid Arshad"
      email        = "javaid.arshad@necsws.com"
      org          = "NEC"
      reason       = "Access is needed for development of a new feature for yjaf"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2023-05-25"
    },
    {
      github_user  = "VasilDimitrov22"
      permission   = "admin"
      name         = "Vasil Dimitrov"
      email        = "vasil.dimitrov@northgateps.com"
      org          = "NEC"
      reason       = "Access is needed for development of a new feature for yjaf"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2023-05-25"
    },
    {
      github_user  = "djv72"
      permission   = "admin"
      name         = "David Vincent"
      email        = "david.vincent@necsws.com"
      org          = "NEC"
      reason       = "Access is needed for development of a new feature for yjaf"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2023-05-25"
    },
    {
      github_user  = "ttipler"
      permission   = "admin"
      name         = "Thomas Tipler"
      email        = "thomas.tipler@necsws.com"
      org          = "NEC"
      reason       = "Access is needed for development of a new feature for yjaf"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2023-05-25"
    },
    {
      github_user  = "craig-ashford"
      permission   = "admin"
      name         = "Craig Ashford"
      email        = "craig.ashford@necsws.com"
      org          = "NEC"
      reason       = "Access is needed for development of a new feature for yjaf"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2023-05-25"
    },
    {
      github_user  = "turtle-nec"
      permission   = "admin"
      name         = "Drew Maughan"
      email        = "drew.maughan@necsws.com"
      org          = "NEC"
      reason       = "Access is needed for development of a new feature for yjaf"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2023-05-25"
    },
    {
      github_user  = "SamMohammedUK"
      permission   = "admin"
      name         = "Sam Mohammed"
      email        = "contact@sammohammed.uk"
      org          = "NEC"
      reason       = "Access is needed for development of a new feature for yjaf"
      added_by     = "Jon Dent jon.dent@justice.gov.uk"
      review_after = "2023-05-25"
    },
  ]
}

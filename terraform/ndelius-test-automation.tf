module "ndelius-test-automation" {
  source     = "./modules/repository-collaborators"
  repository = "ndelius-test-automation"
  collaborators = [
    {
      github_user  = "mlaskowski4"
      permission   = "admin"
      name         = "Michal Laskowski"
      email        = "mlaskowski@unilink.com"
      org          = "Unilink"
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS"
      added_by     = "nicola.hodgkinson@justice.gov.uk"
      review_after = "2024-08-25"
    },
    {
      github_user  = "peter-bcl"
      permission   = "admin"
      name         = "Peter Wilson"
      email        = "pwilson@unilink.com"
      org          = "Unilink"
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS"
      added_by     = "nicola.hodgkinson@justice.gov.uk"
      review_after = "2024-08-25"
    },
    {
      github_user  = "nd070322"
      permission   = "admin"
      name         = "Neale Davison"
      email        = "ndavison@unilink.com"
      org          = "Unilink"
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS"
      added_by     = "nicola.hodgkinson@justice.gov.uk"
      review_after = "2024-08-25"
    },
    {
      github_user  = "jrobson-unilink"
      permission   = "admin"
      name         = "James Robson"
      email        = "jrobson@unilink.com"
      org          = "Unilink"
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS"
      added_by     = "nicola.hodgkinson@justice.gov.uk"
      review_after = "2024-08-25"
    },
    {
      github_user  = "yfedkiv"
      permission   = "admin"
      name         = "Yuri Fedkiv"
      email        = "yfedviv@unilink.com"
      org          = "Unilink"
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS"
      added_by     = "nicola.hodgkinson@justice.gov.uk"
      review_after = "2024-08-25"
    },
    {
      github_user  = "linda182"
      permission   = "admin"
      name         = "Linda Clarke"
      email        = "lclarke@unilink.com"
      org          = "Unilink"
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS"
      added_by     = "nicola.hodgkinson@justice.gov.uk"
      review_after = "2024-08-25"
    },
    {
      github_user  = "madan-thapa"
      permission   = "admin"
      name         = "Madan Thapa"
      email        = "mlaskowski@unilink.com"
      org          = "Unilink"
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS"
      added_by     = "nicola.hodgkinson@justice.gov.uk"
      review_after = "2024-12-21"
    },
    {
      github_user  = "seanvalmonte"
      permission   = "admin"
      name         = "Sean Valmonte"
      email        = "svalmonte@unilink.com"
      org          = "Unilink"
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS"
      added_by     = "nicola.hodgkinson@justice.gov.uk"
      review_after = "2024-12-21"
    },
    {
      github_user  = "andrewrichardson76"
      permission   = "admin"
      name         = "Andrew Richardson"
      email        = "arichardson@unilink.com"
      org          = "Unilink"
      reason       = "To enable Unilink to continue supplying development and testing services to HMPPS"
      added_by     = "nicola.hodgkinson@justice.gov.uk"
      review_after = "2024-12-21"
    },
  ]
}

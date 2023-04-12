module "bichard7-next-shared-infrastructure" {
  source     = "./modules/repository-collaborators"
  repository = "bichard7-next-shared-infrastructure"
  collaborators = [
    {
      github_user  = "bjpirt"
      permission   = "admin"
      name         = "Ben Pirt"
      email        = "ben@madetech.com"
      org          = "Madetech"
      reason       = "CJSE Bichard Development"
      added_by     = "Dom Tomkins <dom.tomkins@digital.justice.gov.uk>"
      review_after = "2023-12-31"
    },
    {
      github_user  = "emadkaramad"
      permission   = "push"
      name         = "Emad Karamad"
      email        = "emad.karamad@madetech.com"
      org          = "Madetech"
      reason       = "CJSE Bichard Development"
      added_by     = "Dom Tomkins <dom.tomkins@digital.justice.gov.uk>"
      review_after = "2023-12-31"
    },
    {
      github_user  = "daviesjamie"
      permission   = "admin"
      name         = "Jamie Davies"
      email        = "jamie.davies@madetech.com"
      org          = "Madetech"
      reason       = "CJSE Bichard Development"
      added_by     = "Dom Tomkins <dom.tomkins@digital.justice.gov.uk>"
      review_after = "2023-12-31"
    },
    {
      github_user  = "monotypical"
      permission   = "push"
      name         = "Alice Lee"
      email        = "alice.lee@madetech.com"
      org          = "Madetech"
      reason       = "CJSE Bichard Development"
      added_by     = "Dom Tomkins <dom.tomkins@digital.justice.gov.uk>"
      review_after = "2023-12-31"
    },
    {
      github_user  = "c-gyorfi"
      permission   = "push"
      name         = "Csaba Gyorfi"
      email        = "csaba@madetech.com"
      org          = "Madetech"
      reason       = "CJSE Bichard Development"
      added_by     = "Dom Tomkins <dom.tomkins@digital.justice.gov.uk>"
      review_after = "2023-12-31"
    },
    {
      github_user  = "joe-fol"
      permission   = "push"
      name         = "Joe Folkard"
      email        = "joe.folkard@madetech.com"
      org          = "Madetech"
      reason       = "CJSE Bichard Development"
      added_by     = "Dom Tomkins <dom.tomkins@digital.justice.gov.uk>"
      review_after = "2023-12-31"
    },
    {
      github_user  = "donnyhyon"
      permission   = "push"
      name         = "Donnie Hyon"
      email        = "donny.hyon@madetech.com"
      org          = "Madetech"
      reason       = "CJSE Bichard Development"
      added_by     = "Dom Tomkins <dom.tomkins@digital.justice.gov.uk>"
      review_after = "2023-12-31"
    },
    {
      github_user  = "agnieszkazbikowska-madetech"
      permission   = "push"
      name         = "Agnieszka Zbikowska"
      email        = "agnieszka.zbikowska@madetech.com"
      org          = "Madetech"
      reason       = "CJSE Bichard Development"
      added_by     = "Dom Tomkins <dom.tomkins@digital.justice.gov.uk>"
      review_after = "2023-12-31"
    },
    {
      github_user  = "ian-antking"
      permission   = "push"
      name         = "Ian King"
      email        = "ian.king@madetech.com"
      org          = "Madetech"
      reason       = "CJSE Bichard Development"
      added_by     = "Dom Tomkins <dom.tomkins@digital.justice.gov.uk>"
      review_after = "2023-12-31"
    },
    {
      github_user  = "Seth-Barber"
      permission   = "pull"
      name         = "Seth Barber"
      email        = "seth.barber@madetech.com"
      org          = "Madetech"
      reason       = "CJSE Bichard Development"
      added_by     = "Dom Tomkins <dom.tomkins@digital.justice.gov.uk>"
      review_after = "2023-12-31"
    },
  ]
}

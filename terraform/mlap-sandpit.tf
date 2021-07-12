module "mlap-sandpit" {
  source     = "./modules/repository-collaborators"
  repository = "mlap-sandpit"
  collaborators = [
    {
      github_user  = "mob-daviesg"
      permission   = "push"
      name         = "Garreth Davies"
      email        = "garreth.davies@mobilise.cloud"
      org          = "Mobilise"
      reason       = "MLAP Beta phase"
      added_by     = "Bartlomiej Bezulski <bartlomiej.bezulski@digital.justice.gov.uk>"
      review_after = "2021-11-30"
    },
    {
      github_user  = "mob-galtryn"
      permission   = "push"
      name         = "Nick Galtry"
      email        = "nick.galtry@mobilise.cloud"
      org          = "Mobilise"
      reason       = "MLAP Beta phase"
      added_by     = "Bartlomiej Bezulski <bartlomiej.bezulski@digital.justice.gov.uk>"
      review_after = "2021-11-30"
    },
    {
      github_user  = "mark-williams-mobilise"
      permission   = "push"
      name         = "Mark Williams"
      email        = "mark.williams@mobilise.cloud"
      org          = "Mobilise"
      reason       = "MLAP Beta phase"
      added_by     = "Bartlomiej Bezulski <bartlomiej.bezulski@digital.justice.gov.uk>"
      review_after = "2021-11-30"
    },
    {
      github_user  = "kevin.davies"
      permission   = "push"
      name         = "Kevin Davies"
      email        = "kevin.davies@mobilise.cloud"
      org          = "Mobilise"
      reason       = "MLAP Beta phase"
      added_by     = "Bartlomiej Bezulski <bartlomiej.bezulski@digital.justice.gov.uk>"
      review_after = "2021-11-30"
    },
    {
      github_user  = "lancemmobilise"
      permission   = "push"
      name         = "Lance Morris"
      email        = "lance.morris@mobilise.cloud"
      org          = "Mobilise"
      reason       = "MLAP Beta phase"
      added_by     = "Bartlomiej Bezulski <bartlomiej.bezulski@digital.justice.gov.uk>"
      review_after = "2021-11-30"
    }
  ]
}

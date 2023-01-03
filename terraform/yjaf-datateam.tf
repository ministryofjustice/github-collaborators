module "yjaf-datateam" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-datateam"
  collaborators = [
    {
      github_user  = "sammohammeduk"
      permission   = "push"
      name         = "Sam Mohammed"
      email        = "sam.mohammed@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "For YJAF data team to store their scripts into the new yjaf data team repo"
      added_by     = "antony.bishop@digital.justice.gov.uk"
      review_after = "2023-12-19"
    },
    {
      github_user  = "anntallis"
      permission   = "push"
      name         = "Ann Meads-Tallis"
      email        = "ann.meads-tallis@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "For YJAF data team to store their scripts into the new yjaf data team repo"
      added_by     = "antony.bishop@digital.justice.gov.uk"
      review_after = "2022-12-19"
    },
    {
      github_user  = "oliviergaubert"
      permission   = "admin"
      name         = "Olivier Gaubert"
      email        = "olivier.gaubert@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "Gareth Davies <gareth.davies@digital.justice.gov.uk> on behalf of the YJB"
      review_after = "2022-12-31"
    },
    {
      github_user  = "andrewtrichards"
      permission   = "admin"
      name         = "Andrew Richards"
      email        = "a.t.richards@btopenworld.com"
      org          = "NEC Software Solutions"
      reason       = "New starter (well returning Dev) working on all YJAF projects etc"
      added_by     = "Gareth Davies <gareth.davies@digital.justice.gov.uk> on behalf of the YJB"
      review_after = "2023-05-26"
    },
    {
      github_user  = "javaidarshadnec"
      permission   = "admin"
      name         = "Javaid Arshad"
      email        = "javaid.arshad@necsws.com"
      org          = "NEC SWS"
      reason       = "Requesting access so I can perhaps start sharing DB workload with Andrew"
      added_by     = "Gareth Davies <gareth.davies@digital.justice.gov.uk> on behalf of the YJB"
      review_after = "2023-08-31"
    },
    {
      github_user  = "vikasnecsws"
      permission   = "admin"
      name         = "Vikas Omar"
      email        = "vikas.omar@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "YJAF (new developer)"
      added_by     = "Gareth Davies <gareth.davies@digital.justice.gov.uk> on behalf of the YJB"
      review_after = "2023-06-07"
    },
    {
      github_user  = "angelanec"
      permission   = "admin"
      name         = "Angela Site"
      email        = "angela.site@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Perform CRUD actions on YJAF"
      added_by     = "Gareth Davies <gareth.davies@digital.justice.gov.uk> on behalf of the YJB"
      review_after = "2023-06-07"
    },
    {
      github_user  = "craig-ashford-nec"
      permission   = "admin"
      name         = "Craig Ashford"
      email        = "craig.ashford@necsws.com"
      org          = "NEC SWS"
      reason       = "New front end developer on YJAF team"
      added_by     = "Tony Bishop antony.bishop@digital.justice.gov.uk"
      review_after = "2023-02-07"
    },
  ]
}

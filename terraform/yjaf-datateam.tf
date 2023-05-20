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
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-12-19"
    },
    {
      github_user  = "oliviergaubert"
      permission   = "admin"
      name         = "Olivier Gaubert"
      email        = "olivier.gaubert@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-12-18"
    },
    {
      github_user  = "andrewtrichards"
      permission   = "admin"
      name         = "Andrew Richards"
      email        = "a.t.richards@btopenworld.com"
      org          = "NEC Software Solutions"
      reason       = "New starter (well returning Dev) working on all YJAF projects etc"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-11-22"
    },
    {
      github_user  = "javaidarshadnec"
      permission   = "admin"
      name         = "Javaid Arshad"
      email        = "javaid.arshad@necsws.com"
      org          = "NEC SWS"
      reason       = "Requesting access so I can perhaps start sharing DB workload with Andrew"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-12-23"
    },
    {
      github_user  = "angelanec"
      permission   = "admin"
      name         = "Angela Site"
      email        = "angela.site@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Perform CRUD actions on YJAF"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-06-07"
    },
    {
      github_user  = "markstanley-nps"
      permission   = "pull"
      name         = "Mark Stanley"
      email        = "mark.stanley@necsws.com"
      org          = "NECSWS"
      reason       = "Developer"
      added_by     = "Mick.Ewers@yjb.gov.uk"
      review_after = "2024-02-15"
    },
  ]
}

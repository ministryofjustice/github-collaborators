module "yjaf-gateway-proxy" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-gateway-proxy"
  collaborators = [
    {
      github_user  = "gregi2n"
      permission   = "admin"
      name         = "Greg Whiting"
      email        = "greg.whiting@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Part of the NEC supplier team for the YJB YJAF system"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-12-13"
    },
    {
      github_user  = "ttipler"
      permission   = "admin"
      name         = "Thomas Tipler"
      email        = "thomas.tipler@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Devops guys need access to make app/infra changes"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-02-24"
    },
    {
      github_user  = "stephenhobden"
      permission   = "push"
      name         = "Stephen Hobden"
      email        = "stephen.hobden@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "Need access to repo for coding tasks"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-02-24"
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
      github_user  = "javaidarshadnec"
      permission   = "admin"
      name         = "Javaid Arshad"
      email        = "javaid.arshad@necsws.com"
      org          = "YJB"
      reason       = "For work on the gateway-proxy project"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-12-23"
    },
    {
      github_user  = "andrewtrichards"
      permission   = "admin"
      name         = "Andrew Richards"
      email        = "a.t.richards@btopenworld.com"
      org          = "NEC Software Solutions"
      reason       = "New starter (well returning Dev) working on all YJAF projects etc"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-05-26"
    },
    {
      github_user  = "robgibsoncapita"
      permission   = "pull"
      name         = "Rob Gibson"
      email        = "Robert.gibson2@capita.com"
      org          = "Capita"
      reason       = "3rd Party Access for network"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-07-22"
    },
    {
      github_user  = "richardwheatleycapita"
      permission   = "pull"
      name         = "Richard Wheatley"
      email        = "richard.wheatley2@capita.com"
      org          = "Capita"
      reason       = "3rd Party Access for network"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-07-22"
    },
    {
      github_user  = "kieran-tanner"
      permission   = "pull"
      name         = "Kieran Tanner"
      email        = "kieran.tanner@oneadvanced.com"
      org          = "OneAdvanced"
      reason       = "3rd Party Access for network"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-07-22"
    },
    {
      github_user  = "paulfitzgerald-advanced"
      permission   = "pull"
      name         = "Paul Fitzgerald"
      email        = "paul.fitzgerald@oneadvanced.com"
      org          = "OneAdvanced"
      reason       = "3rd Party Access for network"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-07-22"
    },
    {
      github_user  = "tmamedova"
      permission   = "pull"
      name         = "Tamilla Medova"
      email        = "tamilla.mamedova@oneadvanced.com"
      org          = "OneAdvanced"
      reason       = "3rd Party Access for network"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-07-22"
    },
    {
      github_user  = "vkolesnikovas"
      permission   = "pull"
      name         = "Vidmantas Kolesnikovas"
      email        = "Vidmantas.Kolesnikovas@oneadvanced.com"
      org          = "OneAdvanced"
      reason       = "3rd Party Access for network"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-01-23"
    },
    {
      github_user  = "bryanmaguireadvanced"
      permission   = "pull"
      name         = "Bryan Maguire"
      email        = "bryan.maguire@oneadvanced.com"
      org          = "OneAdvanced"
      reason       = "3rd Party Access for network"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-07-22"
    },
    {
      github_user  = "ahmedali-necsws"
      permission   = "pull"
      name         = "Ahmed Ali"
      email        = "ahmed.ali@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "3rd Party Access for network"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-01-23"
    },
    {
      github_user  = "balpurewal"
      permission   = "pull"
      name         = "Baldip Purewal"
      email        = "baldip.purewal@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "3rd Party Access for network"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-07-22"
    },
    {
      github_user  = "griffinjuknps"
      permission   = "pull"
      name         = "Jeremy Griffin"
      email        = "jeremy.griffin@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "3rd Party Access for network"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-07-22"
    },
    {
      github_user  = "suraj-necsws"
      permission   = "pull"
      name         = "Sraj Misal"
      email        = "suraj.misal@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "3rd Party Access for network"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-07-22"
    },
    {
      github_user  = "howiedouglasaccessgroup"
      permission   = "pull"
      name         = "Howie Douglas"
      email        = "howie.douglas@theaccessgroup.com"
      org          = "AccessGroup"
      reason       = "3rd Party Access for network"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-07-22"
    },
    {
      github_user  = "abaldwin-caci"
      permission   = "pull"
      name         = "Andrew Baldwin"
      email        = "abaldwin@caci.co.uk"
      org          = "CACI"
      reason       = "3rd Party Access for network"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-02-06"
    },
    {
      github_user  = "schungcaci"
      permission   = "pull"
      name         = "Sai Chung"
      email        = "schung@caci.co.uk"
      org          = "CACI"
      reason       = "3rd Party Access for network"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-02-06"
    },
    {
      github_user  = "adcouth"
      permission   = "pull"
      name         = "Anly DCouth"
      email        = "adcouth@caci.co.uk"
      org          = "CACI"
      reason       = "3rd Party Access for network"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-02-06"
    },
    {
      github_user  = "vcurtis-w14"
      permission   = "pull"
      name         = "Vince Curtis"
      email        = "vcurtis@caci.co.uk "
      org          = "CACI"
      reason       = "3rd Party Access for network"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-02-06"
    },
    {
      github_user  = "ameldrum86"
      permission   = "pull"
      name         = "Anne Meldrum"
      email        = "ameldrum@caci.co.uk "
      org          = "CACI"
      reason       = "3rd Party Access for network"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-02-06"
    },
    {
      github_user  = "yarseyah"
      permission   = "pull"
      name         = "Ray Hayes"
      email        = "ray.hayes@capita.com"
      org          = "CACI"
      reason       = "3rd Party Access for network"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-02-06"
    },
    {
      github_user  = "vikasnecsws"
      permission   = "admin"
      name         = "Vikas Omar"
      email        = "vikas.omar@necsws.com"
      org          = "NEC Software Solutions"
      reason       = "YJAF (new developer)"
      added_by     = "Mick Ewers <Mick.Ewers@yjb.gov.uk> on behalf of the YJB"
      review_after = "2023-06-07"
    },
  ]
}

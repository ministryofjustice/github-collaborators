module "alpha_cjs_va_dashboard" {
  source     = "./modules/repository-collaborators"
  repository = "alpha_cjs_va_dashboard"
  collaborators = [
    {
      github_user  = "lewissheppard"
      permission   = "push"
      name         = "Lewis Sheppard"
      email        = "lewis.sheppard@cps.gov.uk"
      org          = "CPS"
      reason       = "We work closely with the CPS on a project called the Alpha-CJS data set which aims to bring together and link data from MoJ, CPS and the police. These CPS colleagues are already members of our existing repo on moj-analytical-services where we collaborate on producing analysis using the Alpha-CJS dataset. We have recently set up this new repo on ministryofjustice as we have been commissioned to produce an MVP dashboard to display some of our metrics which we will want to deploy on the Cloud Platform. As such, we now need to add our CPS colleagues so that they can help in the building of the dashboard."
      added_by     = "laura.williams2@justice.gov.uk, vinoth.mohanram@justice.gov.uk"
      review_after = "2025-03-31"
    },
    {
      github_user  = "OviB9"
      permission   = "push"
      name         = "Ovidiu Brudan"
      email        = "ovidiu.brudan@cps.gov.uk"
      org          = "CPS"
      reason       = "We work closely with the CPS on a project called the Alpha-CJS data set which aims to bring together and link data from MoJ, CPS and the police. These CPS colleagues are already members of our existing repo on moj-analytical-services where we collaborate on producing analysis using the Alpha-CJS dataset. We have recently set up this new repo on ministryofjustice as we have been commissioned to produce an MVP dashboard to display some of our metrics which we will want to deploy on the Cloud Platform. As such, we now need to add our CPS colleagues so that they can help in the building of the dashboard."
      added_by     = "laura.williams2@justice.gov.uk, vinoth.mohanram@justice.gov.uk"
      review_after = "2025-03-31"
    },
  ]
}

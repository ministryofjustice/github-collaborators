module "yjaf-devops-infrastructure" {
  source     = "./modules/repository-collaborators"
  repository = "yjaf-devops-infrastructure"
  collaborators = {
    brbaje-dev = "push"
    chris-nps = "push"
    oliviergaubert = "push"
    gregi2n = "admin"
    griffinjuknps = "push"
    AndrewRichards72 = "push"
  }
}

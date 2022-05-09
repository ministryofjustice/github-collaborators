module "ansible-users" {
  source     = "./modules/repository-collaborators"
  repository = "ansible-users"
  collaborators = [

  ]
}

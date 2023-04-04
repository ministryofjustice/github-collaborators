provider "github" {
  owner = "ministryofjustice"
  # Enable this to run locally and comment out the app_auth block
  # token = var.github_token
  #   write_delay_ms = "1000"
  #   read_delay_ms  = "1000"

  app_auth {
    id              = var.app_id
    installation_id = var.app_installation_id
    pem_file        = var.app_pem_file
  }
}
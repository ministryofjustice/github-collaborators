provider "github" {
  owner = "ministryofjustice"
  # Enable this to run locally and comment out the app_auth block
  # token = var.github_token
  #   write_delay_ms = "1000"
  #   read_delay_ms  = "1000"

  app_auth {
    id              = GITHUB_APP_ID
    installation_id = GITHUB_APP_INSTALLATION_ID
    pem_file        = GITHUB_APP_PEM_FILE
  }
}
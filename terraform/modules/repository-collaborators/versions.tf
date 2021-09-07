terraform {
  required_version = ">= 0.14"
  required_providers {
    github = {
      version = "4.0"
      source  = "integrations/github"
    }
  }
}

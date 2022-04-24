terraform {

  cloud {
    organization = "morgan-peat-ec"

    workspaces {
      name = "bootstrap"
    }
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.4.0"
    }
    random = {
      version = "~> 3.1.0"
    }
    time = {
      version = "~> 0.7.2"
    }
    tfe = {
      version = "~> 0.30.2"
    }
    vault = {
      version = "3.1.1"
    }
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}


##############################################################
# Creates a new GCP Project
#
# Pretty simple in this demo, but IRL would:
# - Attach to a shared VPC
# - Enable enterprise logging & monitoring
# - Give access to 'approved' container and OS image
#
# Remember, this is a demo. Many variables etc are hard-coded
# and clearly not meant for production.
##############################################################

/*
# Give every project a random name - don't use corporate names anywhere
resource "random_pet" "default" {
  length    = 2
  separator = "-"
}

resource "random_id" "default" {
  byte_length = 2
}

locals {
  project_id = format("%s-%s", random_pet.default.id, random_id.default.hex)
}


# Create the new project
resource "google_project" "default" {
  name            = var.name
  project_id      = var.project_id
  billing_account = var.gcp_billing_account
}

# Hard-coded services. In reality these would be passed as
# variable and would depend on what the project is used for.
locals {
  apis = [
    "cloudresourcemanager.googleapis.com",
    "iamcredentials.googleapis.com",
    "iam.googleapis.com",
    "cloudapis.googleapis.com",
    "compute.googleapis.com",
    "storage.googleapis.com",
    "cloudbilling.googleapis.com",
    "serviceusage.googleapis.com",
  ]
}

resource "google_project_service" "apis" {
  for_each = toset(local.apis)
  project  = local.project_id
  service  = each.value
}


*/
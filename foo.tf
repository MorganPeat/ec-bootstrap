##############################################################
# Configures the platform for an application
#
# Configuration is held centrally in this demo, but with
# suitable guardrails it could be distributed.
# Application teams could raise PRs against this repo to add
# their environments
##############################################################




# Configure TFC teams

resource "tfe_team" "foo_developers" {
  name         = "foo-developers"
  organization = var.tfc_organization
}

resource "tfe_team" "foo_admins" {
  name         = "foo-admins"
  organization = var.tfc_organization
}


# Configure Environments

module "dev" {
  source = "./modules/environment-factory"

  project_id          = "foo-dev-348219"
  name                = "foo"
  environment         = "dev"
  gcp_billing_account = var.gcp_billing_account
  tfc_organization    = var.tfc_organization

  tfc_writers = [tfe_team.foo_admins.id]
  tfc_readers = [tfe_team.foo_developers.id]
}


# foo-int-348219
# foo-prod-348219
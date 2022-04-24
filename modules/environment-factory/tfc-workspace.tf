
#####################################################
# TFC workspace for this GCP Project
#
# Each GCP project has its own workspaces for resources. This
# enables RBAC and keeps projects separate.
# TF state is held here.
#####################################################

resource "tfe_workspace" "resources" {
  organization      = var.tfc_organization
  name              = "${var.name}-${var.environment}-resources"
  terraform_version = "1.1.1" # must match template version
  working_directory = "environments/${var.environment}"
}

#####################################################
# TF workspace variables
#
# Let terraform know which GCP Project it is working
# against.
#####################################################
resource "tfe_variable" "project_id" {
  workspace_id = tfe_workspace.resources.id
  key          = "project_id"
  category     = "terraform"
  value        = var.project_id
}

# Generate a new GCP Service Account key
data "vault_generic_secret" "gcp_credentials" {
  path = "gcp/roleset/${var.name}-${var.environment}-owner/key"
}

resource "tfe_variable" "gcp_credentials" {
  workspace_id = tfe_workspace.resources.id
  key          = "GOOGLE_CREDENTIALS"
  category     = "env"
  value        = replace(base64decode(data.vault_generic_secret.gcp_credentials.data["private_key_data"]), "\n", "")
  sensitive    = true
}

#####################################################
# Terraform teams
#
# Teams are granted permission to the workspace
#####################################################


# Writers can 'terraform apply'

resource "tfe_team" "writer" {
  organization = var.tfc_organization
  name         = "${tfe_workspace.resources.name}-writer"
}

resource "tfe_team_access" "writer" {
  workspace_id = tfe_workspace.resources.id
  team_id      = tfe_team.writer.id
  permissions {
    runs              = "apply"
    variables         = "read"
    state_versions    = "read-outputs"
    sentinel_mocks    = "none"
    workspace_locking = false
  }
}

resource "vault_terraform_cloud_secret_role" "writer" {
  backend      = "terraform"
  organization = var.tfc_organization
  name         = "${tfe_workspace.resources.name}-writer"
  team_id      = tfe_team.writer.id
}



# Readers can 'terraform plan'

resource "tfe_team" "reader" {
  organization = var.tfc_organization
  name         = "${tfe_workspace.resources.name}-reader"
}

resource "tfe_team_access" "reader" {
  workspace_id = tfe_workspace.resources.id
  team_id      = tfe_team.reader.id

  permissions {
    runs              = "plan"
    variables         = "read"
    state_versions    = "read-outputs"
    sentinel_mocks    = "none"
    workspace_locking = false
  }
}

resource "vault_terraform_cloud_secret_role" "reader" {
  backend      = "terraform"
  organization = var.tfc_organization
  name         = "${tfe_workspace.resources.name}-reader"
  team_id      = tfe_team.reader.id
}

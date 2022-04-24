##############################################################
# Module registry
#
# Use this file to register new modules (git repos) into TFC
#
# Not part of this demo - done manually.
##############################################################


/*
data "tfe_oauth_client" "github" {
  # Find in Settings / VCS Providers / <your provider> / <in Edit Client URL>
  oauth_client_id = "oc-tfVyzjGQiPLcZ2NP"
}

resource "tfe_registry_module" "ec_storage_module" {
  vcs_repo {
    display_identifier = "MorganPeat/terraform-google-ec-storage-module"
    identifier         = "MorganPeat/terraform-google-ec-storage-module"
    oauth_token_id     = data.tfe_oauth_client.github.oauth_token_id
  }
}
*/
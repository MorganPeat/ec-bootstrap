# ec-bootstrap
Enterprise Cloud - platform bootstrapper

Bootstraps up the basics of an enterprise cloud platform.

## Terraform Cloud

Set up Terraform Cloud so it can be used by the platform.

1. Log in to https://app.terraform.io/
1. Create a new organization manually
1. Upgrade to a free trial of the "Team & Governance" plan
1. Set up an OAth connection to GitHub in Settings / Providers
   1. Follow the instructions in TFC
   1. Skip the SSH setup

## Publish modules

Control the module registry via terraform
**Not working**

## Set up Vault

Sets up a tiny dev instance of Vault - anything more is outside the scope of this demo

1. Create a new GCP project
1. Start up a small VM.
   1. Enable HTTP access
   1. Open a firewall to port 8200
1. Install Vault
   1. Instructions at https://learn.hashicorp.com/tutorials/vault/getting-started-install
   1. May need extra package, see https://itsfoss.com/add-apt-repository-command-not-found/
1. Run vault in dev mode
   1. `vault server -dev -dev-listen-address="[::]:8200" -dev-root-token-id=some-root-token-id -log-level=debug`
1. Confirm its accessible from your desktop
   * `export VAULT_ADDR="http://vault-vm-ip-address:8200"`
   * `export VAULT_TOKEN="your-root-token"`
   * `vault status`
1. Configure vault
   *1.* Run `configure-vault.sh`
1. Set GCP credentials (ADCs) in the vault vm
  * `gcloud auth application-default login`

## Set up the bootstrap TFC workspace

Set up a workspace for the bootstrapper / environment admin

1. In TFC create a new CLI-driven workspace "bootstrap"
1. Configure the backend for this repo to point to the bootstrap workspace
1. Set some (sensitive) variables in the workspace
   * tfc_org_api_token
   * gcp_billing_account
   * tfc_organization
   * VAULT_ADDR (env)
   * VAULT_TOKEN (env)
   * TFE_TOKEN (env) - to user API token


## Start it all up

Get the bootstrapper working

1. Log into terraform using `terraform login`
1. Run the bootstrap
   * `terraform init`
   * `terraform plan` etc

#! /usr/bin/env bash

# VAULT_ADDR and VAULT_TOKEN must be set


# Enable audit logs for debugging
vault audit enable file file_path=stdout log_raw=true

# Simple K/V store
vault secrets enable -version=1 kv

# Credentials needed to set up each environment
# This is fugly, but hey - it's a demo :)
vault kv put kv/bootstrap vault_token=<vault token> tfe_token=<your user tf api token>


# Manage TFC team API tokens
vault secrets enable terraform
vault write terraform/config token=<your user tf api token>


# GCP service accounts
vault secrets enable gcp

# Create a GCP Roleset for each project so creds can be read from vault
vault write gcp/roleset/foo-dev-owner \
    project="foo-dev-348219" \
    secret_type="service_account_key"  \
    bindings=-<<EOF
      resource "//cloudresourcemanager.googleapis.com/projects/foo-dev-348219" {
        roles = ["roles/owner"]
      }
EOF

vault write gcp/roleset/foo-int-owner \
    project="foo-int-348219" \
    secret_type="service_account_key"  \
    bindings=-<<EOF
      resource "//cloudresourcemanager.googleapis.com/projects/foo-int-348219" {
        roles = ["roles/owner"]
      }
EOF


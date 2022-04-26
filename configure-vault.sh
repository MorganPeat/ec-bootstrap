#! /usr/bin/env bash

# VAULT_ADDR and VAULT_TOKEN must be set


# Enable audit logs for debugging
vault audit enable file file_path=stdout log_raw=true

# Simple K/V store
vault secrets enable -version=1 kv

# Credentials needed to set up each environment
# This is fugly, but hey - it's a demo :)
vault kv put kv/bootstrap vault_token=<vault token> tfe_token=<your user tf api token>

# GCP service accounts
vault secrets enable gcp

# Manage TFC team API tokens
vault secrets enable terraform
vault write terraform/config token=<your user tf api token>

# Allow GitHub authentication
vault auth enable jwt
vault write auth/jwt/config oidc_discovery_url="https://token.actions.githubusercontent.com" bound_issuer="https://token.actions.githubusercontent.com"

# Massive cheat (its a demo...) - in reality we would have fine-grained
# policies for each repo / environment combination
vault policy write github - <<EOF
 path "kv/*" {
   capabilities = [ "read" ]
 }
 path "gcp/*" {
   capabilities = [ "read" ]
 }
 path "auth/*" {
   capabilities = [ "read", "update" ]
 }
 path "terraform/*" {
   capabilities = [ "read" ]
 }
  
EOF








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

# Allow GitHub auth for each environment
vault write auth/jwt/role/foo-dev-reader - <<EOF
{
    "role_type": "jwt", 
    "user_claim": "actor", 
    "policies": "github", 
    "token_explicit_max_ttl": "1h", 
    "bound_claims": { 
        "repository" : "MorganPeat/ec-foo-application-iac",
        "environment" : "dev" 
    }
}
EOF

vault write auth/jwt/role/foo-dev-writer - <<EOF
{
    "role_type": "jwt", 
    "user_claim": "actor", 
    "policies": "github", 
    "token_explicit_max_ttl": "1h", 
    "bound_claims": { 
        "repository" : "MorganPeat/ec-foo-application-iac",
        "environment" : "dev"  
    }
}
EOF

vault write auth/jwt/role/foo-int-reader - <<EOF
{
    "role_type": "jwt", 
    "user_claim": "actor", 
    "policies": "github", 
    "token_explicit_max_ttl": "1h", 
    "bound_claims": { 
        "repository" : "MorganPeat/ec-foo-application-iac",
        "environment" : "int"  
    }
}
EOF

vault write auth/jwt/role/foo-int-writer - <<EOF
{
    "role_type": "jwt", 
    "user_claim": "actor", 
    "policies": "github", 
    "token_explicit_max_ttl": "1h", 
    "bound_claims": { 
        "repository" : "MorganPeat/ec-foo-application-iac",
        "environment" : "int"  
    }
}
EOF

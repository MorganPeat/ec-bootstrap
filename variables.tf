variable "tfc_organization" {
  description = "The name of the Terraform Cloud organization in which to create the application's workspace"
  type        = string
}

variable "region" {
  type        = string
  description = "Region in which to deploy"

  default = "europe-west1" # Belgium, slightly cheaper than London
}

variable "gcp_billing_account" {
  description = "The GCP billing account to charge to"
  type        = string
}


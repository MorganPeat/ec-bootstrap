variable "project_id" {
  description = "For the purposes of this demo (no GCP Org) projects are manually created"
  type        = string
}

variable "name" {
  description = "The name for the project"
  type        = string
}

variable "environment" {
  description = "The type of environment e.g. DEV, UAT"
  type        = string
}

variable "gcp_billing_account" {
  description = "The GCP billing account to charge to"
  type        = string
}

variable "tfc_organization" {
  description = "The name of the Terraform Cloud organization in which to create the application's workspace"
  type        = string
}

variable "tfc_writers" {
  description = "TFC teams that have 'write' (aka apply) permission"
  type        = list(string)
}

variable "tfc_readers" {
  description = "TFC teams that have 'read' (aka plan) permission"
  type        = list(string)
}
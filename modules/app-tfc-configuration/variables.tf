variable "tfc_organization" {
  description = "The name of the Terraform Cloud organization in which to create the application's workspace"
  type        = string
}

variable "tfc_org_api_token" {
  description = "Terraform Cloud Organization API token"
  type        = string
  sensitive   = true
}

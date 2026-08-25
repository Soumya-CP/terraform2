variable "subscription_id" {
  description = "Azure subscription ID in which to create the resources."
  type        = string
}

variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "East Asia"
}

variable "admin_username" {
  description = "Administrator username for the Linux VM."
  type        = string
  default     = "azureadmin"
}

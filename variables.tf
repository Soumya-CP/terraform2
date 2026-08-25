variable "subscription_id" {
  description = "Azure subscription ID in which to create the resources."
  type        = string
}

variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "Central India"
}

variable "admin_username" {
  description = "Administrator username for the Linux VM."
  type        = string
  default     = "azureadmin"
}

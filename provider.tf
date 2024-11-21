terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc3"
    }
  }
}

variable "pm_endpoint" {
  type = string
}
variable "pm_user" {
  type = string
}
variable "pm_pass" {
  type = string
  sensitive = true
}
variable "pm_api_token_id" {
  type = string
  sensitive = true
}
variable "pm_api_token_secret" {
  type = string
  sensitive = true
}
variable "srv_pass" {
  type = string
  sensitive = false
}
provider "proxmox" {
  pm_api_url = var.pm_endpoint
  pm_user = var.pm_user
  pm_password = var.pm_pass
  pm_api_token_id = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure = true
}
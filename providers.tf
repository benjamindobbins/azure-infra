provider "azurerm" {
  features {}
  subscription_id = "feeae5a6-a248-4d09-891d-7f5f6cf0464b"  # Your subscription ID
}
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
}
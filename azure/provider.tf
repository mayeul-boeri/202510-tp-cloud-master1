terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
}

provider "azurerm" {
	features {}
	subscription_id = "6c58833b-2b1e-4253-9f15-cd9721c0fc7f"
}
terraform {
  required_providers {
    azurerm={
        source = "hashicorp/azure"
        version = "~> 3.0.2"
    }

  }

  cloud {
    organization = "Myorg"
    workspaces {
      name = "Azure-Terraform"
    }
  }

    required_version = ">= 1.1.0"

}
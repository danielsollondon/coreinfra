terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.72.0"
    }
  }

  # Update this block with the location of your terraform state file
  backend "azurerm" {
    resource_group_name  = "rg-terraform-github-actions-state"
    storage_account_name = "tfgh001"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_oidc             = true
  }
}

provider "azurerm" {
  features {}
  use_oidc = true
}

resource "azurerm_kubernetes_cluster" "aks001" {
  name                = "aks001"
  location            = "westus2"
  resource_group_name = "prod-clu-grp01"
  dns_prefix          = "aks001-k8s"

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_DS2_v2"
  }

  lifecycle {
  ignore_changes = [
    default_node_pool[0].node_count,
  ]
  }
  identity {
    type = "SystemAssigned"
  }

  role_based_access_control_enabled = true

}




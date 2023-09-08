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
  name                 = "aks001"
  location             = "westus3"
  resource_group_name  = "prod-clu-grp01"
  dns_prefix           = "aks001-k8s"
  azure_policy_enabled = true

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_DS2_v2"
  }

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count, tags, monitor_metrics
    ]
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control_enabled = true

}


resource "azurerm_kubernetes_cluster_extension" "aks001" {
  name           = "aks001-ext"
  cluster_id     = azurerm_kubernetes_cluster.aks001.id
  extension_type = "microsoft.flux"
}

resource "azurerm_kubernetes_flux_configuration" "aks001" {
  name       = "aks001-fc"
  cluster_id = azurerm_kubernetes_cluster.aks001.id
  namespace  = "flux"

  git_repository {
    url             = "https://github.com/danielsollondon/appteam2"
    reference_type  = "branch"
    reference_value = "main"
  }

  kustomizations {
    name = "appconfig"
    path = "./prod"
  }

  depends_on = [
    azurerm_kubernetes_cluster_extension.aks001
  ]
}




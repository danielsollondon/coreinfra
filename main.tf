terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0"
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

# add clusters & azure resources here

#### dev cluster 001
resource "azurerm_kubernetes_cluster" "aks001" {
  name                = "aks001"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "${random_pet.prefix.id}-k8s"

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control_enabled = true

  tags = {
    CostCentre = "AI001"
    Owner = "RupertS"
  }
}

resource "azurerm_kubernetes_cluster_extension" "aks001" {
  name           = "aks001-ext"
  cluster_id     = azurerm_kubernetes_cluster.test.id
  extension_type = "microsoft.flux"
}

resource "azurerm_kubernetes_flux_configuration" "aks001" {
  name       = "aks001-fc"
  cluster_id = azurerm_kubernetes_cluster.test.id
  namespace  = "flux"

### add your repo here
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

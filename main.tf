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

### CLUSTER CONFIGS BELOW ### 


### AI team 001 ### 
resource "azurerm_kubernetes_cluster" "aks001" {
  name                 = "aks001"
  location             = "westus3"
  resource_group_name  = "prod-clu-grp01"
  dns_prefix           = "aks001-k8s"
  azure_policy_enabled = true

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
  }

  lifecycle {
    ignore_changes = [
      tags, monitor_metrics, microsoft_defender, oms_agent
    ]
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control_enabled = true

  tags = {
    Environment = "Test",
    Owner       = "PeterKay",
    CostCenter  = "AI001"
  }

}



resource "azurerm_kubernetes_cluster_extension" "aks001-extn" {
  name           = "aks001-extn"
  cluster_id     = azurerm_kubernetes_cluster.aks001.id
  extension_type = "microsoft.flux"

  depends_on = [
    azurerm_role_assignment.regrole
  ]
}

resource "azurerm_kubernetes_flux_configuration" "appteam2-app2" {
  name       = "appteam2-app2"
  cluster_id = azurerm_kubernetes_cluster.aks001.id
  namespace  = "flux"
  scope      = "cluster"

  git_repository {
    url             = "https://github.com/danielsollondon/appteam2"
    reference_type  = "branch"
    reference_value = "main"
  }

  kustomizations {
    name = "appconfig"
    path = "./staging"
  }

  depends_on = [
    azurerm_kubernetes_cluster_extension.aks001-extn
  ]
}


resource "azurerm_role_assignment" "regrole" {
  principal_id                     = azurerm_kubernetes_cluster.aks001.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = "/subscriptions/e049fcf1-c84b-4de4-ba9a-a168a4cbab7a/resourceGroups/acrgrp/providers/Microsoft.ContainerRegistry/registries/dansregwu3"
  skip_service_principal_aad_check = true

  depends_on = [
    azurerm_kubernetes_cluster.aks001

  ]
}

### AI team 001 END ###



### AI team 002 ### 
resource "azurerm_kubernetes_cluster" "aks002" {
  name                 = "aks002"
  location             = "westus3"
  resource_group_name  = "prod-clu-grp01"
  dns_prefix           = "aks002-k8s"
  azure_policy_enabled = true

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_DS2_v2"
  }

  lifecycle {
    ignore_changes = [
      tags, monitor_metrics, microsoft_defender, oms_agent
    ]
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control_enabled = true

  tags = {
    Environment = "Test",
    Owner       = "PeterKay"
  }

}



resource "azurerm_kubernetes_cluster_extension" "aks002-extn" {
  name           = "aks002-extn"
  cluster_id     = azurerm_kubernetes_cluster.aks002.id
  extension_type = "microsoft.flux"

  depends_on = [
    azurerm_role_assignment.regrole
  ]
}

resource "azurerm_kubernetes_flux_configuration" "appteam2-aks002" {
  name       = "appteam2-aks002"
  cluster_id = azurerm_kubernetes_cluster.aks002.id
  namespace  = "flux"
  scope      = "cluster"

  git_repository {
    url             = "https://github.com/danielsollondon/appteam2"
    reference_type  = "branch"
    reference_value = "main"
  }

  kustomizations {
    name = "appconfig"
    path = "./staging"
  }

  depends_on = [
    azurerm_kubernetes_cluster_extension.aks002-extn
  ]
}


resource "azurerm_role_assignment" "regrole-aks002" {
  principal_id                     = azurerm_kubernetes_cluster.aks002.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = "/subscriptions/e049fcf1-c84b-4de4-ba9a-a168a4cbab7a/resourceGroups/acrgrp/providers/Microsoft.ContainerRegistry/registries/dansregwu3"
  skip_service_principal_aad_check = true

  depends_on = [
    azurerm_kubernetes_cluster.aks002

  ]
}

### AI team 002 END ### 


### AI team 003 ### 
resource "azurerm_kubernetes_cluster" "aks003" {
  name                 = "aks003"
  location             = "westus3"
  resource_group_name  = "prod-clu-grp01"
  dns_prefix           = "aks003-k8s"
  azure_policy_enabled = true

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_DS2_v2"
  }

  lifecycle {
    ignore_changes = [
      tags, monitor_metrics, microsoft_defender, oms_agent
    ]
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control_enabled = true

  tags = {
    Environment = "Test",
    Owner       = "PeterKay"
  }

}



resource "azurerm_kubernetes_cluster_extension" "aks003-extn" {
  name           = "aks003-extn"
  cluster_id     = azurerm_kubernetes_cluster.aks003.id
  extension_type = "microsoft.flux"

  depends_on = [
    azurerm_role_assignment.regrole
  ]
}

resource "azurerm_kubernetes_flux_configuration" "appteam2-aks003" {
  name       = "appteam2-aks003"
  cluster_id = azurerm_kubernetes_cluster.aks003.id
  namespace  = "flux"
  scope      = "cluster"

  git_repository {
    url             = "https://github.com/danielsollondon/appteam2"
    reference_type  = "branch"
    reference_value = "main"
  }

  kustomizations {
    name = "appconfig"
    path = "./staging"
  }

  depends_on = [
    azurerm_kubernetes_cluster_extension.aks003-extn
  ]
}


resource "azurerm_role_assignment" "regrole-aks003" {
  principal_id                     = azurerm_kubernetes_cluster.aks003.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = "/subscriptions/e049fcf1-c84b-4de4-ba9a-a168a4cbab7a/resourceGroups/acrgrp/providers/Microsoft.ContainerRegistry/registries/dansregwu3"
  skip_service_principal_aad_check = true

  depends_on = [
    azurerm_kubernetes_cluster.aks003

  ]
}

### AI team 03 END ### 










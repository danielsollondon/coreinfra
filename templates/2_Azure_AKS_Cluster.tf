### REPLACE CLUSTERNAME
resource "azurerm_kubernetes_cluster" "CLUSTERNAME" {
  name                 = "CLUSTERNAME"
  location             = "westus3"
  resource_group_name  = "prod-clu-grp01"
  dns_prefix           = "CLUSTERNAME-k8s"
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
    Owner       = "PeterKay",
    CostCenter  = "AI001"
  }

}



resource "azurerm_kubernetes_cluster_extension" "CLUSTERNAME-extn" {
  name           = "CLUSTERNAME-extn"
  cluster_id     = azurerm_kubernetes_cluster.CLUSTERNAME.id
  extension_type = "microsoft.flux"

  depends_on = [
    azurerm_role_assignment.regrole
  ]
}

resource "azurerm_kubernetes_flux_configuration" "appteam2-app2" {
  name       = "appteam2-app2"
  cluster_id = azurerm_kubernetes_cluster.CLUSTERNAME.id
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
    azurerm_kubernetes_cluster_extension.CLUSTERNAME-extn
  ]
}


resource "azurerm_role_assignment" "regrole" {
  principal_id                     = azurerm_kubernetes_cluster.CLUSTERNAME.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = "/subscriptions/e049fcf1-c84b-4de4-ba9a-a168a4cbab7a/resourceGroups/acrgrp/providers/Microsoft.ContainerRegistry/registries/dansregwu3"
  skip_service_principal_aad_check = true

  depends_on = [
    azurerm_kubernetes_cluster.CLUSTERNAME

  ]
}

### END ### 



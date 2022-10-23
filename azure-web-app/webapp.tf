resource "azurerm_resource_group" "main" {
  name = "rg-${var.project_unique_id}"
  location = var.azure_default_location
}

resource "azurerm_service_plan" "main-linux-docker" {
  name = "${var.project_unique_id}-main-linux-docker"
  resource_group_name = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location
  os_type = "Linux"
  sku_name = "B1"
}

resource "azurerm_linux_web_app" "main-linux-docker" {
  name = "${var.project_unique_id}-main-linux-docker"
  resource_group_name = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location
  service_plan_id = azurerm_service_plan.main-linux-docker.id
  https_only = false

  site_config {
    application_stack {
      docker_image = "mcr.microsoft.com/azuredocs/containerapps-helloworld"
      docker_image_tag = "latest"
    }
  }
}

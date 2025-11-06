terraform {
  required_providers {
    restapi = {
      source  = "Mastercard/restapi"
      version = "1.20.0"
    }
  }
}

module "resource_provider_accounts" {
  source   = "./resource-provider"
  depends_on = [ restapi_object.resource_classes ]

  name     = var.resource_provider_name
  email    = var.resource_provider_email
  info_url = var.resource_provider_info_url
  accounts = var.accounts
  allocations = var.allocations

  providers = {
    restapi.coral = restapi.coral
  }
}

resource "restapi_object" "resource_classes" {
  provider = restapi.coral

  for_each = toset(var.resource_classes)
  path     = "/resource_class"
  data = jsonencode({
    "name" : each.value
  })
}

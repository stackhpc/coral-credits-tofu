terraform {
  required_providers {
    restapi = {
      source               = "Mastercard/restapi"
      version              = "1.20.0"
      configuration_aliases = [ restapi.coral ]
    }
  }
}

resource "restapi_object" "resource_provider" {
    provider       = restapi.coral
    path           = "/resource_provider"
    data =  jsonencode({
        "name": var.name,
        "email": var.email,
        "info_url": var.info_url
    })
}

module "accounts" {
  source = "../account"
  for_each = var.accounts

  name = each.key
  email = each.value.email
  allocations = each.value.allocations

  providers = {
    restapi.coral = restapi.coral
  }
}

resource "restapi_object" "resource_provider_accounts" {
    provider       = restapi.coral

    for_each = var.accounts
    path           = "/resource_provider_account"
    data =  jsonencode({
        "account": module.accounts[each.key].id_url,
        "provider": resource.restapi_object.resource_provider.api_data.url,
        "project_id": each.value.openstack_project_id
    })
}


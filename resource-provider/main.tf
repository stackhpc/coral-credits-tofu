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
  source = "../resource_provider_account"
  for_each = var.accounts

  depends_on = [ restapi_object.resource_provider ]

  name = each.key
  email = each.value.email
  allocations = each.value.allocations
  resource_provider_id_url = resource.restapi_object.resource_provider.api_data.url
  openstack_project_id = each.value.openstack_project_id

  providers = {
    restapi.coral = restapi.coral
  }
}


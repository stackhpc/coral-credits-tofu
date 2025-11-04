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

locals {
  flattened_allocations = flatten([for key, a in var.allocations: 
    [for index, p in a.projects: {
      name = "${key}-${index}"
      account_email = p.account_email
      start_date = a.start_date 
      end_date = a.end_date
      resources = p.resources
    }]
  ])
}

module "accounts" {
  source = "../resource_provider_account"
  for_each = { for a in var.accounts: a.name => a }

  depends_on = [ restapi_object.resource_provider ]

  name = each.value.name
  email = each.value.email
  allocations = [for a in local.flattened_allocations: a if a.account_email == each.value.email ]
  resource_provider_id_url = resource.restapi_object.resource_provider.api_data.url
  openstack_project_id = each.value.openstack_project_id

  providers = {
    restapi.coral = restapi.coral
  }
}


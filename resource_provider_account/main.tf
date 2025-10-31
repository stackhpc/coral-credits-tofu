terraform {
  required_providers {
    restapi = {
      source               = "Mastercard/restapi"
      version              = "1.20.0"
      configuration_aliases = [ restapi.coral ]
    }
  }
}

resource "restapi_object" "account" {
    provider       = restapi.coral

    path = "/account"
    data = jsonencode({
        "name": var.name,
        "email": var.email
    })
}

output "id_url" {
    value = resource.restapi_object.account.api_data.url
}

resource "restapi_object" "resource_provider_account" {
    provider       = restapi.coral

    depends_on = [ restapi_object.account ]

    path           = "/resource_provider_account"
    data =  jsonencode({
        "account": resource.restapi_object.account.api_data.url,
        "provider": var.resource_provider_id_url,
        "project_id": var.openstack_project_id
    })
}

module "allocations" {
    source = "../allocation"

    depends_on = [ restapi_object.resource_provider_account ]

    for_each = var.allocations

    name = each.key
    start_date = each.value.start_date
    end_date = each.value.end_date
    account_id_url = resource.restapi_object.account.api_data.url
    resources = each.value.resources
    
    providers = {
      restapi.coral = restapi.coral
    }
}
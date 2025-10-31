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

module "allocations" {
    source = "../allocation"

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
terraform {
  required_providers {
    restapi = {
      source               = "Mastercard/restapi"
      version              = "1.20.0"
      configuration_aliases = [ restapi.coral ]
    }
  }
}

resource "restapi_object" "allocation" {
    provider       = restapi.coral

    path           = "/allocation"
    data =  jsonencode({
        "name": var.name,
        "account": var.account_id_url,
        "start": var.start_date,
        "end": var.end_date
    })
}

resource "restapi_object" "allocation_resources" {
    provider = restapi.coral

    path = "/allocation/${resource.restapi_object.allocation.api_data.id}/resources"
    data = jsonencode(var.resources)
}

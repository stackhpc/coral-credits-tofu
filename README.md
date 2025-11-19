# Coral Credits OpenTofu Module

OpenTofu module for declaratively managing [Coral Credits](https://github.com/stackhpc/coral-credits) allocations for OpenStack projects.

## Requirements

The module requires its `restapi.coral` provider to be set to the `Mastercard/restapi` provider, which should be configured to connect to
and authenticate with your Coral Credits server with a provided bearer token and with its configuration options set as shown in the example
config below.

## Example Configuration

```
terraform {
  required_providers {
    restapi = {
      source  = "Mastercard/restapi"
      version = "1.20.0"
    }
  }
}

# Should be secret set as environment variable TF_VAR_auth_token,
# retrieve token by running:
# export TF_VAR_auth_token=$(curl -s -X POST -H "Content-Type: application/json" -d \
#     "{
#         \"username\": \"admin\", 
#         \"password\": \"<coral_admin_password-from-azimuth-secrets>\"
#     }" \
#     http<s>://credits.apps.<azimuth-domain>/api-token-auth/ | jq -r '.token')
variable "auth_token" {
    type = string
}

provider "restapi" {
  alias                 = "coral"
  uri                   = http<s>://credits.apps.<azimuth-domain>
  write_returns_object  = true
  create_returns_object = true
  id_attribute = "id"
  headers = {
    "Content-Type" = "application/json"
    Authorization  = "Bearer var.auth_token"
  }
}

module "coral_tofu" {
    source = "git::https://github.com/stackhpc/coral-credits-tofu.git?ref=<current-release-version>"
    
    resource_provider_name     = "Test Provider"
    resource_provider_email    = "testprovider@example.com"
    resource_provider_info_url = "https://www.example.com"

    providers = {
        restapi.coral = restapi.coral
    }
    
    accounts = [
    {
        name                 = "TestAccount1"
        email                = "testaccount1@example.com"
        openstack_project_id = "c2eced313b324cdb8e670e6e30bf387d"
    },
    {
        name                 = "TestAccount2"
        email                = "testaccount2@example.com"
        openstack_project_id = "2fbf511968aa443e883a82283b0f0160"
    }
    ]

    allocations = {
        Q1 = {
            start_date = "2025-09-01-12:00:00"
            end_date   = "2025-12-01-12:00:00"
            projects = [
            {
                account_email = "testaccount1@example.com"
                resources = {
                VCPU      = 40000
                MEMORY_MB = 4423680
                DISK_GB   = 108000
                }
            },
            {
                account_email = "testaccount2@example.com"
                resources = {
                VCPU      = 20000
                MEMORY_MB = 2000000
                DISK_GB   = 200000
                }
            }
            ]
        }
        Q2 = {
            start_date = "2026-01-01-12:00:00"
            end_date   = "2026-04-01-12:00:00"
            projects = [
            {
                account_email = "testaccount1@example.com"
                resources = {
                VCPU      = 80000
                MEMORY_MB = 8000000
                DISK_GB   = 300000
                }
            }
            ]
        }
    }
}
```
## Configuration options
See [variables.tf](./variables.tf) for full detailed configuration options.

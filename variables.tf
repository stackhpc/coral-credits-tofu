variable "coral_uri" {
  type = string
}

# TODO: should we be setting the coral admin password instead and fetching a new token for
# each run? Depends how long lived the tokens are
variable "auth_token" {
  type = string
}

variable "resource_provider_name" {
  type = string
}

variable "resource_provider_email" {
  type = string
}

variable "resource_provider_info_url" {
  type = string
}

variable "allocations" {
  type = map(any)
}

variable "accounts" {
  type = list(map(string))
}

variable "resource_classes" {
  type    = list(string)
  default = ["VCPU", "MEMORY_MB", "DISK_GB"]
}

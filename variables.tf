variable "coral_uri" {
  type = string
}

# TODO: should we be setting the coral admin password instead and fetching a new token for
# each run? Depends how long lived the tokens are
variable "auth_token" {
  type = string
}

variable "resource_providers" {
  type        = map(any)
  description = <<-EOF
        name: string
        email: string
        info_url: string
        accounts: [{ name: string, email: string }]
    EOF
}

variable "resource_classes" {
  type    = list(string)
  default = ["VCPU", "RAM_MB", "DISK_GB"]
}

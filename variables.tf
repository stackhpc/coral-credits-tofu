variable "resource_provider_name" {
  type = string
  description = "Name to identify a resource provider created for the target cloud with"
}

variable "resource_provider_email" {
  type = string
  description = "Email address to be associated with the cloud's resource provider"
}

variable "resource_provider_info_url" {
  type = string
  description = "Valid URL for an info page for the cloud's resource provider"
}

variable "allocations" {
  type = map(any)
  description = <<-EOT
    Map of allocation names to maps defining allocation objects. Allocation object maps contain key/value pairs:
      start_date: Date-time string in format "YYYY-MM-DD-HH:MM:SS" for when the allocation will become
                  active for each of the associated projects
      end_date: Date-time string in format "YYYY-MM-DD-HH:MM:SS" for when the allocation will expire
                expire for each of the projects
      projects: List of maps which associate accounts with resource requests. Key/value pairs:
        account_email: Email address which must match an 'email' field from 'accounts' to associate
                       resources with that account's OpenStack project
        resources: Map of resource name strings to the integer number of resource hours of that resource to assign
                   to the allocation. Keys must match a resource defined in 'resource_classes'.
  EOT

  validation {
    condition = alltrue([
      for _, alloc in var.allocations :
      alltrue([
        for proj in alloc.projects : alltrue([
          for r in keys(proj.resources) : contains(var.resource_classes, r)
        ])
      ])
    ])
    error_message = "All resources allocated in projects must be defined in var.resource_classes"
  }

  validation {
    condition = alltrue([
      for _, alloc in var.allocations :
      alltrue([
        for p in alloc.projects : contains([for acct in var.accounts : acct.email], p.account_email)
      ])
    ])
    error_message = "All project.account_email values in allocations must match one of the emails in var.accounts"
  }

}

variable "accounts" {
  type = list(map(string))
  description = <<-EOT
    List of maps of strings defining accounts. Map key/value pairs:
      name: Name to be associated with account
      email: Email address to be associated with account
      openstack_project_id: ID of OpenStack project to allocate credits to for this account
  EOT
}

variable "resource_classes" {
  type    = list(string)
  default = ["VCPU", "MEMORY_MB", "DISK_GB"]
  description = <<-EOT
    List of OpenStack resources defined by Openstack's os-resource-classes library
    https://opendev.org/openstack/os-resource-classes/src/branch/master/os_resource_classes/__init__.py
    to manage Coral Credits allocations for
  EOT
}

variable "name" {
    type = string
}

variable "email" {
    type = string
}

variable "allocations" {
    type = list(any)
}

variable "resource_provider_id_url" {
    type = string
}

variable "openstack_project_id" {
    type = string
}

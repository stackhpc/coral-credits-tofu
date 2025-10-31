variable "name" {
    type = string
}

variable "email" {
    type = string
}

variable "info_url" {
    type = string
}

variable "accounts" {
    type = map(any)
    description = <<-EOF
        name: string
        email: string
        openstack_project_id: string
        allocations: map(any)
    EOF
}

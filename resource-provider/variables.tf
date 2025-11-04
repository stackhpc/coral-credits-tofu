variable "name" {
    type = string
}

variable "email" {
    type = string
}

variable "info_url" {
    type = string
}

variable "allocations" {
    type = map(any) 
}

variable "accounts" {
    type = list(map(string))
}
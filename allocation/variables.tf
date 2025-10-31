variable "name" {
    type = string
}

variable "account_id_url" {
    type = string
}

variable "start_date" {
    type = string
}

variable "end_date" {
    type = string
}

variable "resources" {
    type = map(number)
}

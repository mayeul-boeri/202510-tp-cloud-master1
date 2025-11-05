variable "project_name" {
    description = "The name of the project to be used in resource naming."
    type        = string
}

variable "location" {
  type = string
}

variable "vnet_cidr" {
    type = string
    default = "10.1.0.0/16"
}

variable "subnets" {
    type = list(object({
        name           = string
        cidr           = string
        zone           = list(number)
        type           = string
    }))
}
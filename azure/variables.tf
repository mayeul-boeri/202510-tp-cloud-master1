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

variable "sql_administrator_login" {
  description = "The administrator login for the SQL Server."
  type        = string
}

variable "sql_administrator_password" {
  description = "The administrator password for the SQL Server."
  type        = string
  sensitive   = true
}

variable "sql_connection_string" {
  description = "The SQL connection string to be stored in Key Vault."
  type        = string
}

variable "vmss_username" {
  description = "username for ubuntu instance"
  type = string
}

variable "vmss_password" {
  description = "password for ubuntu instance"
  type = string
  sensitive = true
}


variable "sql_useradmin_login" {
  description = "The user admin login for the SQL Server."
  type        = string
}

variable "sql_useradmin_password" {
  description = "The user admin password for the SQL Server."
  type        = string
  sensitive   = true
}
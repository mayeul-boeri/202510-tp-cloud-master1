variable "project_id" {
  type = string
}

variable "name" {
  type = string
}

variable "location" {
  type    = string
  default = "US"
}

variable "versioning" {
  type    = bool
  default = false
}

variable "force_destroy" {
  type    = bool
  default = false
}

variable "lifecycle_days" {
  type    = number
  default = 365
}

variable "kms_key_name" {
  type    = string
  default = ""
}

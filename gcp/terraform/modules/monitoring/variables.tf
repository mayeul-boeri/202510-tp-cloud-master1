variable "project_id" {
  type = string
}

variable "notification_email" {
  type    = string
  default = ""
}

variable "create_notification_channel" {
  type    = bool
  default = false
}

variable "enable_uptime_check" {
  type    = bool
  default = false
}

variable "uptime_host" {
  type    = string
  default = ""
}

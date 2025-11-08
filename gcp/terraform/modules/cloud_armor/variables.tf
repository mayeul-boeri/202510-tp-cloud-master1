variable "security_policy_name" {
  type        = string
  description = "Name of the Cloud Armor security policy"
  default     = "tpcloud-security-policy"
}

variable "description" {
  type        = string
  description = "Description for the security policy"
  default     = "Security policy for TP Cloud scaffold"
}

variable "block_ip_ranges" {
  type        = list(string)
  description = "List of IP ranges to block (deny)"
  default     = []
}

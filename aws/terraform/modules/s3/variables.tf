variable "project_name" {
  type = string
}

variable "bucket_name" {
  description = "Optional explicit bucket name. If empty, a unique name will be generated from project_name."
  type        = string
  default     = ""
}

variable "enable_acl" {
  description = "Whether to manage ACLs on the bucket. Set to false if your account enforces 'Bucket owner enforced' and ACLs are not supported."
  type        = bool
  default     = false
}

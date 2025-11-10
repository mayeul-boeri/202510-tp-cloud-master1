variable "project_id" {
  type        = string
  description = "GCP project id to deploy into"
}

variable "region" {
  type        = string
  description = "Region for the router and NAT"
  default     = "us-central1"
}

variable "router_name" {
  type        = string
  description = "Name of the Cloud Router to create"
  default     = "tpcloud-router"
}

variable "nat_name" {
  type        = string
  description = "Name of the Cloud NAT resource"
  default     = "tpcloud-nat"
}

variable "network_self_link" {
  type        = string
  description = "Self link of the VPC network where the router will be attached"
}

variable "nat_ip_allocate_option" {
  type        = string
  description = "NAT IP allocation option (AUTO_ONLY or MANUAL_ONLY)"
  default     = "AUTO_ONLY"
}

variable "source_subnetwork_ip_ranges_to_nat" {
  type        = string
  description = "Which subnets/IP ranges are NATed (e.g. ALL_SUBNETWORKS_ALL_IP_RANGES)"
  default     = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

variable "subnetwork_self_links" {
  type        = list(string)
  description = "List of subnet self_links to use when source_subnetwork_ip_ranges_to_nat is LIST_OF_SUBNETWORKS"
  default     = []
}

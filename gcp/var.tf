variable "name" {
  default     = "rampage"
  description = "cluster name"
}

variable "region" {
  default     = ""
  description = "region"
}

variable "node_count" {
  default     = 1
  description = "no of worker nodes"
}

variable "machine_type" {
  default     = ""
  description = "machine type of worker nodes"
}
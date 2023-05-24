variable "name" {
  default     = "rampage"
  description = "cluster name"
}

variable "region" {
  default     = "us-central1-c"
  description = "region"
}

variable "node_count" {
  default     = 1
  description = "no of worker nodes"
}

variable "machine_type" {
  default     = "e2-micro"
  description = "machine type of worker nodes"
}
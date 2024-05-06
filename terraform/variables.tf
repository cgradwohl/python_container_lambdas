variable "state_bucket_name" {
  type        = string
  description = "The name of the state bucket for the backend."
}

variable "state_lockable_name" {
  type        = string
  description = "The name of the state bucket for the backend."
}

variable "state_bucket_path" {
  type        = string
  description = "The name of the path the Terraform state is written to."
}

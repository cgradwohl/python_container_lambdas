variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources."
}

variable "state_bucket_name" {
  type        = string
  description = "Remote backend state bucket."
}

variable "state_locktable_name" {
  type        = string
  description = "Remote backend state lock table."
}

variable "state_locktable_read_capacity" {
  type        = number
  description = "Remote backend state lock table read capacity."
}

variable "state_locktable_write_capacity" {
  type        = number
  description = "Remote backend state lock table write capacity."
}

variable "name_prefix" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "kms_key_arn" {
  type = string
}

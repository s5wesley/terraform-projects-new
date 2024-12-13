variable "secret_name" {
  description = "The name of the secret"
  type        = string
}

variable "secret_description" {
  description = "The description of the secret"
  type        = string
  default     = ""
}

variable "name" {
  description = "The name to be stored in the secret"
  type        = string
}

variable "password" {
  description = "The password to be stored in the secret"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}

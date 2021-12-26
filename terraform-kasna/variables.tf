variable "project_name" {
  description = "(Required) The project name"
  type = string
}

variable "folder_id" {
  description = "(Required) The folder id"
  type = string
}

variable "user" {
  description = "(Required) The user email address"
  type = string
}

variable "billing_account" {
  description = "(Required) The billing account"
  type = string
}

variable "repository_name" {
  default = "wild-workouts"
}

variable "location" {
  default = "australia-southeast1"
}
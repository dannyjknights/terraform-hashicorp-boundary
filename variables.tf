variable "boundary_org_name" {
  type        = string
  description = "Name of the Org Scope"
}

variable "boundary_project_name" {
  type        = string
  description = "Name of the Project Scope"
}

variable "boundary_addr" {
  type        = string
  description = "Boundary URL"
}

variable "password_auth_method_login_name" {
  type        = string
  description = "Boundary Admin UI Login Name"
}

variable "password_auth_method_password" {
  type        = string
  description = "Boundary Admin UI Password"
}
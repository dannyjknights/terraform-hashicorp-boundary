terraform {
  # cloud {
  #   organization = "HashiCorp-Partner-Lab"

  #   workspaces {
  #     name = "boundary_logical"
  #   }
  # }
  required_providers {
    boundary = {
      source  = "hashicorp/boundary"
      version = ">=1.1.10"
    }
  }
}

provider "boundary" {
  # Configuration options
  addr = var.boundary_addr
  //auth_method_id                  = var.auth_method_id
  password_auth_method_login_name = var.password_auth_method_login_name
  password_auth_method_password   = var.password_auth_method_password
}

# Create an organisation scope within global, named "ops-org"
# The global scope can contain multiple org scopes
resource "boundary_scope" "org" {
  scope_id                 = "global"
  name                     = var.boundary_org_name
  auto_create_default_role = true
  auto_create_admin_role   = true
}

/* Create a project scope within the "ops-org" organsiation
Each org can contain multiple projects and projects are used to hold
infrastructure-related resources
*/
resource "boundary_scope" "project" {
  name                     = var.boundary_project_name
  scope_id                 = boundary_scope.org.id
  auto_create_admin_role   = true
  auto_create_default_role = true
}

resource "boundary_auth_method" "partner_auth_method" {
  scope_id = boundary_scope.org.id
  type     = "password"
  name     = "Partner Login"
}

resource "boundary_account_password" "partner_auth_password" {
  auth_method_id = boundary_auth_method.partner_auth_method.id
  //type           = "password"
  login_name = var.password_auth_method_login_name
  password   = var.password_auth_method_password
}

resource "boundary_user" "partner_user" {
  scope_id    = boundary_scope.org.id
  name        = "Partner User"
  description = "Username for each Partner"
  account_ids = [boundary_account_password.partner_auth_password.id]

}

resource "boundary_role" "partner_role" {
  scope_id      = boundary_scope.org.id
  description   = "Partner Role per their Org"
  name          = "Partner Role"
  principal_ids = [boundary_user.partner_user.id]
  grant_strings = ["id=${boundary_scope.org.id};type=scope;actions=*"]



}


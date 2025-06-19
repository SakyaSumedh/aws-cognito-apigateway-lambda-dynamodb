resource "aws_cognito_user_pool" "pool" {
  count = var.create_cognito ? 1 : 0
  name = "${local.slug}-pool"
  auto_verified_attributes = [ "email" ]
  deletion_protection = "ACTIVE"
  account_recovery_setting {
    recovery_mechanism {
      name = "verified_email"
      priority = 2
    }
  }
  password_policy {
    minimum_length = 8
    password_history_size = 2
    require_lowercase = true
    require_numbers = true
    require_symbols = true
    require_uppercase = true
    temporary_password_validity_days = 1
  }
  
  sign_in_policy {
    allowed_first_auth_factors = [ "PASSWORD" ]
  }

  user_pool_tier = "ESSENTIALS"
  username_attributes = [  ]
  username_configuration {
    case_sensitive = true
  }
  schema {
    name = "email"
    attribute_data_type = "String"
    mutable = true
    required = true
    string_attribute_constraints {
      min_length = 10
      max_length = 100
    }
  }
  schema {
    name = "name"
    attribute_data_type = "String"
    mutable = true
    required = true
    string_attribute_constraints {
      min_length = 10
      max_length = 100
    }
  }
  schema {
    name = "is_admin"
    attribute_data_type = "Boolean"
    mutable = true
    required = false
  }
}


resource "aws_cognito_user_pool_domain" "domain" {
  count = var.create_cognito ? 1 : 0
  user_pool_id = aws_cognito_user_pool.pool.id
  domain = local.slug
}


resource "aws_cognito_user_pool_client" "client" {
  count = var.create_cognito ? 1 : 0
  name = "${local.slug}-client"
  user_pool_id = aws_cognito_user_pool.pool.id

  prevent_user_existence_errors = "ENABLED" 
  enable_token_revocation = true
  generate_secret = true
  explicit_auth_flows = ["ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH" ]
  
  read_attributes = [ "email", "name" ]
  write_attributes = [ "email", "name" ]

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows = [ "code", "implicit" ]
  allowed_oauth_scopes = [ "openid", "email" ]
  supported_identity_providers = ["COGNITO"]
  callback_urls = [ "http://localhost:3000", "http://localhost:8000" ]
  logout_urls = [ "http://localhost:3000" ]
  
  auth_session_validity = 5  # minutes
  access_token_validity = 10
  refresh_token_validity = 1
  id_token_validity = 1
  token_validity_units {
    access_token = "minutes"
    refresh_token = "days"
    id_token = "hours"
  }
}

output "pool_client" {
  value = aws_cognito_user_pool_client.client.client_secret
  sensitive = true
}
variable "AWS_ROLE_ARN" {}

variable "AWS_REGION" {
  default = "ap-south-1"
}

variable "create_s3" {
  type = bool
  default = false
}

variable "create_dynamodb" {
  type = bool
  default = false
}

variable "create_cognito" {
  type = bool
  default = false
}

variable "create_lambda" {
  type = bool
  default = false
}

variable "create_api_gateway" {
  type = bool
  default = false
}
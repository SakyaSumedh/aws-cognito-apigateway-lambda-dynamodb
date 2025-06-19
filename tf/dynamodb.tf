resource "aws_dynamodb_table" "expense-table" {
  count = var.create_dynamodb ? 1 : 0
  name = local.slug
  hash_key = "Id"
  billing_mode = "PROVISIONED"
  read_capacity = 2
  write_capacity = 2
  deletion_protection_enabled = true

  point_in_time_recovery {
    enabled = true
  }

  attribute {
    name = "Id"
    type = "S"
  }
  attribute {
    name = "UserId"
    type = "S"
  }
  attribute {
    name = "Timestamp"
    type = "S"
  }

  global_secondary_index { 
    name = "UserId-Timestamp-GlobalIndex"
    hash_key = "UserId"
    range_key = "Timestamp"
    projection_type = "KEYS_ONLY"
    read_capacity = 2
    write_capacity = 3
  }
}
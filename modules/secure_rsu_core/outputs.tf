output "rsu_table_name" {
  value = aws_dynamodb_table.rsu_state.name
}

output "rsu_table_arn" {
  value = aws_dynamodb_table.rsu_state.arn
}

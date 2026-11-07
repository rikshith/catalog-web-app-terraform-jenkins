output "vpc_id" {
  description = "ID of the project VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets, ordered by Availability Zone"
  value = [
    for key in sort(keys(aws_subnet.public)) :
    aws_subnet.public[key].id
  ]
}

output "app_subnet_ids" {
  description = "IDs of the private application subnets, ordered by Availability Zone"
  value = [
    for key in sort(keys(aws_subnet.app)) :
    aws_subnet.app[key].id
  ]
}

output "database_subnet_ids" {
  description = "IDs of the private database subnets, ordered by Availability Zone"
  value = [
    for key in sort(keys(aws_subnet.database)) :
    aws_subnet.database[key].id
  ]
}

output "nat_gateway_id" {
  description = "ID of the NAT gateway"
  value       = aws_nat_gateway.this.id
}
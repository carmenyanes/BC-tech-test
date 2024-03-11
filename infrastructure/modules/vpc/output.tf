output "vpc_id" {
  value = aws_vpc.main.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "private_subnet_ids" {
  value = [
    aws_subnet.private-us-east-1a.id,
    aws_subnet.private-us-east-1b.id,
  ]
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public-us-east-1a.id,
    aws_subnet.public-us-east-1b.id,
  ]
}

output "nat_eip" {
  value = aws_eip.nat.id
}

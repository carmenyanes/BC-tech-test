output "vpc_id" {
  value = aws_vpc.main.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "private_subnet_ids" {
  value = [
    aws_subnet.private-a.id,
    aws_subnet.private-b.id,
  ]
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public-a.id,
    aws_subnet.public-b.id,
  ]
}

output "nat_eip" {
  value = aws_eip.nat.id
}

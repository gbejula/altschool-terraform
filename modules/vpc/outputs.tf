output "region" {
  value = var.region
}

output "subnet_az1_cidr" {
  value = var.subnet-az1-cidr
}

output "internet_gateway" {
  value = aws_internet_gateway.inter-gate
}
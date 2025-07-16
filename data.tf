data "cato_allocatedIp" "primary" {
  name_filter = [var.primary_public_cato_ip]
}

data "cato_allocatedIp" "secondary" {
  name_filter = [var.secondary_public_cato_ip]
}
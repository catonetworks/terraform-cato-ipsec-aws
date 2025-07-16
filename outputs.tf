##The following attributes are exported:
output "primary_vpn_connection_id" {
  description = "ID of the created AWS VPN connection"
  value       = aws_vpn_connection.primary_vpn_connection.id
}

output "secondary_vpn_connection_id" {
  description = "ID of the created AWS VPN connection"
  value       = aws_vpn_connection.secondary_vpn_connection.id
}


output "primary_tunnel_address" {
  value = aws_vpn_connection.primary_vpn_connection.tunnel1_address
}

output "secondary_tunnel_address" {
  value = aws_vpn_connection.secondary_vpn_connection.tunnel1_address
}

output "tunnel1_preshared_key" {
  value     = aws_vpn_connection.primary_vpn_connection.tunnel1_preshared_key
  sensitive = true
}

output "tunnel2_preshared_key" {
  value     = aws_vpn_connection.secondary_vpn_connection.tunnel1_preshared_key
  sensitive = true
}

output "site_id" {
  description = "ID of the created Cato IPSec site"
  value       = cato_ipsec_site.ipsec-site.id
}

output "cato_license_site" {
  value = var.license_id == null ? null : {
    id           = cato_license.license[0].id
    license_id   = cato_license.license[0].license_id
    license_info = cato_license.license[0].license_info
    site_id      = cato_license.license[0].site_id
  }
}

output "vpc_id" {
  description = "ID of the created Cato IPSec site"
  value       = var.vpc_id == null ? aws_vpc.cato-vpc[0].id : var.vpc_id
}
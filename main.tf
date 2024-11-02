
provider "aws" {
  region = var.region
}

provider "cato" {
  baseurl    = var.baseurl
  token      = var.token
  account_id = var.account_id
}

# Create 2 allocated IPs in Cato, Get IDs

# Create AWS resources
resource "aws_customer_gateway" "cgw" {
  bgp_asn    = var.bgp_asn
  ip_address = var.cgw_ip
  type       = "ipsec.1"
}

resource "aws_vpn_gateway" "vgw" {
  vpc_id = var.vpc_id
}

resource "aws_vpn_connection" "vpn_connection" {
  customer_gateway_id = aws_customer_gateway.cgw.id
  vpn_gateway_id      = aws_vpn_gateway.vgw.id
  type                = "ipsec.1"
}

# Create Cato ipsec site and tunnels
resource "cato_ipsec_site" "ipsec-site" {
  name                 = var.site_name
  site_type            = var.site_type
  description          = var.site_description
  native_network_range = var.native_network_range
  site_location        = var.site_location
  ipsec = {
    primary = {
      destination_type  = var.primary_destination_type
      public_cato_ip_id = var.primary_public_cato_ip_id
      pop_location_id   = var.primary_pop_location_id
      tunnels = [
        {
          public_site_ip  = aws_vpn_connection.vpn_connection.tunnel1_address
          private_cato_ip = var.primary_private_cato_ip
          private_site_ip = var.primary_private_site_ip
          psk             = aws_vpn_connection.vpn_connection.tunnel1_preshared_key
          last_mile_bw = {
            downstream = var.downstream_bw
            upstream   = var.upstream_bw
            # downstream_mbps_precision = 1
            # upstream_mbps_precision = 1
          }
        }
      ]
    }
    secondary = {
      destination_type  = var.secondary_destination_type
      public_cato_ip_id = var.secondary_public_cato_ip_id
      pop_location_id   = var.secondary_pop_location_id
      tunnels = [
        {
          public_site_ip  = aws_vpn_connection.vpn_connection.tunnel2_address
          private_cato_ip = var.secondary_private_cato_ip
          private_site_ip = var.secondary_private_site_ip
          psk             = aws_vpn_connection.vpn_connection.tunnel2_preshared_key
          last_mile_bw = {
            downstream = var.downstream_bw
            upstream   = var.upstream_bw
            # downstream_mbps_precision = 1
            # upstream_mbps_precision = 1
          }
        }
      ]
    }
  }
}
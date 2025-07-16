resource "aws_vpc" "cato-vpc" {
  count      = var.vpc_id == null ? 1 : 0
  cidr_block = var.native_network_range
  tags = merge({
    Name = "${var.site_name}-VPC"
  }, var.tags)
}

# Create AWS resources
resource "aws_customer_gateway" "primary_customer_gateway" {
  bgp_asn     = var.cato_bgp_asn
  ip_address  = var.primary_public_cato_ip
  type        = "ipsec.1"
  device_name = "cato-networks-cloud-primary"

  tags = merge({
    Name = "${var.site_name}-primary-customer-gateway"
  }, var.tags)
}

resource "aws_customer_gateway" "secondary_customer_gateway" {
  bgp_asn     = var.cato_bgp_asn
  ip_address  = var.secondary_public_cato_ip
  type        = "ipsec.1"
  device_name = "cato-networks-cloud-secondary"

  tags = merge({
    Name = "${var.site_name}-secondary-customer-gateway"
  }, var.tags)
}

resource "aws_vpn_gateway" "vgw" {
  vpc_id          = var.vpc_id == null ? aws_vpc.cato-vpc[0].id : var.vpc_id
  amazon_side_asn = var.aws_bgp_asn
  tags = merge({
    Name = "${var.site_name}-Virtual_Gateway"
  }, var.tags)
}

resource "aws_vpn_gateway_attachment" "vpn_attachment" {
  vpc_id         = var.vpc_id == null ? aws_vpc.cato-vpc[0].id : var.vpc_id
  vpn_gateway_id = aws_vpn_gateway.vgw.id
}

resource "aws_vpn_connection" "primary_vpn_connection" {
  customer_gateway_id = aws_customer_gateway.primary_customer_gateway.id
  vpn_gateway_id      = aws_vpn_gateway.vgw.id
  tunnel1_inside_cidr = var.primary_vpn_tunnel1_inside_cidr
  type                = "ipsec.1"
  tags = merge({
    Name = "${var.site_name}-primary-vpn-connection"
  }, var.tags)
}

resource "aws_vpn_connection" "secondary_vpn_connection" {
  customer_gateway_id = aws_customer_gateway.secondary_customer_gateway.id
  vpn_gateway_id      = aws_vpn_gateway.vgw.id
  tunnel1_inside_cidr = var.secondary_vpn_tunnel1_inside_cidr
  type                = "ipsec.1"
  tags = merge({
    Name = "${var.site_name}-secondary-vpn-connection"
  }, var.tags)
}

# Create Cato ipsec site and tunnels
resource "cato_ipsec_site" "ipsec-site" {
  name                 = var.site_name
  site_type            = var.site_type
  description          = var.site_description
  native_network_range = var.native_network_range
  site_location        = local.cur_site_location
  ipsec = {
    primary = {
      destination_type  = var.primary_destination_type
      public_cato_ip_id = data.cato_allocatedIp.primary.items[0].id
      pop_location_id   = var.primary_pop_location_id
      tunnels = [
        {
          public_site_ip  = aws_vpn_connection.primary_vpn_connection.tunnel1_address
          private_cato_ip = var.primary_private_cato_ip
          private_site_ip = var.primary_private_site_ip
          psk             = aws_vpn_connection.primary_vpn_connection.tunnel1_preshared_key
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
      public_cato_ip_id = data.cato_allocatedIp.secondary.items[0].id
      pop_location_id   = var.secondary_pop_location_id
      tunnels = [
        {
          public_site_ip  = aws_vpn_connection.secondary_vpn_connection.tunnel1_address
          private_cato_ip = var.secondary_private_cato_ip
          private_site_ip = var.secondary_private_site_ip
          psk             = aws_vpn_connection.secondary_vpn_connection.tunnel1_preshared_key
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

resource "cato_bgp_peer" "primary" {
  site_id                  = cato_ipsec_site.ipsec-site.id
  name                     = var.cato_primary_bgp_peer_name == null ? "${var.site_name}-primary-bgp-peer" : var.cato_primary_bgp_peer_name
  cato_asn                 = var.cato_bgp_asn
  peer_asn                 = var.aws_bgp_asn
  peer_ip                  = var.primary_private_site_ip
  metric                   = var.cato_primary_bgp_metric
  default_action           = var.cato_primary_bgp_default_action
  advertise_all_routes     = var.cato_primary_bgp_advertise_all
  advertise_default_route  = var.cato_primary_bgp_advertise_default_route
  advertise_summary_routes = var.cato_primary_bgp_advertise_summary_route
  md5_auth_key             = "" #Inserting Blank Value to Avoid State Changes 

  bfd_settings = {
    transmit_interval = var.cato_primary_bgp_bfd_transmit_interval
    receive_interval  = var.cato_primary_bgp_bfd_receive_interval
    multiplier        = var.cato_primary_bgp_bfd_multiplier
  }
  # Inserting Ignore to avoid API and TF Fighting over a Null Value 
  lifecycle {
    ignore_changes = [
      summary_route
    ]
  }
}

resource "cato_bgp_peer" "backup" {
  site_id                  = cato_ipsec_site.ipsec-site.id
  name                     = var.cato_secondary_bgp_peer_name == null ? "${var.site_name}-secondary-bgp-peer" : var.cato_secondary_bgp_peer_name
  cato_asn                 = var.cato_bgp_asn
  peer_asn                 = var.aws_bgp_asn
  peer_ip                  = var.secondary_private_site_ip
  metric                   = var.cato_secondary_bgp_metric
  default_action           = var.cato_secondary_bgp_default_action
  advertise_all_routes     = var.cato_secondary_bgp_advertise_all
  advertise_default_route  = var.cato_secondary_bgp_advertise_default_route
  advertise_summary_routes = var.cato_secondary_bgp_advertise_summary_route
  md5_auth_key             = "" #Inserting Blank Value to Avoid State Changes 

  bfd_settings = {
    transmit_interval = var.cato_secondary_bgp_bfd_transmit_interval
    receive_interval  = var.cato_secondary_bgp_bfd_receive_interval
    multiplier        = var.cato_secondary_bgp_bfd_multiplier
  }

  lifecycle {
    ignore_changes = [
      summary_route
    ]
  }
}


resource "cato_license" "license" {
  depends_on = [cato_ipsec_site.ipsec-site]
  count      = var.license_id == null ? 0 : 1
  site_id    = cato_ipsec_site.ipsec-site.id
  license_id = var.license_id
  bw         = var.license_bw == null ? null : var.license_bw
}

variable "cato_bgp_asn" {
  description = "BGP ASN for the customer gateway"
  type        = number
}

variable "aws_bgp_asn" {
  description = "BGP ASN for the customer gateway"
  type        = number
}

variable "vpc_id" {
  description = "The VPC ID where the VPN gateway will be attached"
  type        = string
  default     = null
}

variable "primary_vpn_tunnel1_inside_cidr" {
  description = "Primary VPN, Tunnel 1 Inside CIDR"
  type        = string
  default     = "169.254.100.0/30"
}

variable "secondary_vpn_tunnel1_inside_cidr" {
  description = "Primary VPN, Tunnel 2 Inside CIDR"
  type        = string
  default     = "169.254.200.0/30"
}


# Cato Variables
variable "site_name" {
  description = "Name of the IPSec site"
  type        = string
}

variable "site_description" {
  description = "Description of the IPSec site"
  type        = string
}

variable "native_network_range" {
  description = "Native network range for the IPSec site"
  type        = string
}

variable "site_type" {
  description = "The type of the site"
  type        = string
  default     = "CLOUD_DC"
  validation {
    condition     = contains(["DATACENTER", "BRANCH", "CLOUD_DC", "HEADQUARTERS"], var.site_type)
    error_message = "The site_type variable must be one of 'DATACENTER','BRANCH','CLOUD_DC','HEADQUARTERS'."
  }
}

variable "region" {
  description = "AWS region where resources will be deployed."
  type        = string
}

variable "site_location" {
  description = "Site location which is used by the Cato Socket to connect to the closest Cato PoP. If not specified, the location will be derived from the Azure region dynamicaly."
  type = object({
    city         = string
    country_code = string
    state_code   = string
    timezone     = string
  })
  default = {
    city         = null
    country_code = null
    state_code   = null ## Optional - for countries with states
    timezone     = null
  }
}

variable "primary_private_cato_ip" {
  description = "Private IP address of the Cato side for the primary tunnel"
  type        = string
}

variable "primary_private_site_ip" {
  description = "Private IP address of the site side for the primary tunnel"
  type        = string
}

variable "primary_public_cato_ip" {
  description = "Public IP address ID of the Cato side for the primary tunnel"
  type        = string
}

variable "primary_destination_type" {
  description = "The destination type of the IPsec tunnel"
  # validation {
  #   condition     = var.primary_destination_type == null || contains(["FQDN","IPv4"], var.primary_destination_type)
  #   error_message = "The site_type variable must be one of 'FQDN','IPv4'."
  # }
  # nullable    = true
  type    = string
  default = null
}

variable "primary_pop_location_id" {
  description = "Primary tunnel POP location ID"
  type        = string
  default     = null
}

variable "secondary_private_cato_ip" {
  description = "Private IP address of the Cato side for the secondary tunnel"
  type        = string
}

variable "secondary_private_site_ip" {
  description = "Private IP address of the site side for the secondary tunnel"
  type        = string
}

variable "secondary_public_cato_ip" {
  description = "Public IP address ID of the Cato side for the secondary tunnel"
  type        = string
}

variable "secondary_destination_type" {
  description = "The destination type of the IPsec tunnel"
  # validation {
  #   condition     = var.secondary_destination_type == null || contains(["FQDN","IPv4"], var.secondary_destination_type)
  #   error_message = "The destination_type variable must be one of 'FQDN','IPv4'."
  # }
  # nullable    = true
  type    = string
  default = null
}

variable "secondary_pop_location_id" {
  description = "Secondary tunnel POP location ID"
  type        = string
  default     = null
}

variable "downstream_bw" {
  description = "Downstream bandwidth in Mbps"
  type        = number
}

variable "upstream_bw" {
  description = "Upstream bandwidth in Mbps"
  type        = number
}

variable "license_id" {
  description = "The license ID for the Cato vSocket of license type CATO_SITE, CATO_SSE_SITE, CATO_PB, CATO_PB_SSE.  Example License ID value: 'abcde123-abcd-1234-abcd-abcde1234567'.  Note that licenses are for commercial accounts, and not supported for trial accounts."
  type        = string
  default     = null
}

variable "license_bw" {
  description = "The license bandwidth number for the cato site, specifying bandwidth ONLY applies for pooled licenses.  For a standard site license that is not pooled, leave this value null. Must be a number greater than 0 and an increment of 10."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of Key-Value Tags"
  default     = null
  type        = map(any)
}

variable "cato_primary_bgp_peer_name" {
  description = "Cato Primary BGP Peer Name"
  type        = string
  default     = null
}

variable "cato_secondary_bgp_peer_name" {
  description = "Cato Secondary BGP Peer Name"
  type        = string
  default     = null
}

variable "cato_primary_bgp_default_action" {
  description = "Cato Primary BGP Default Action"
  type        = string
  default     = "ACCEPT"
}

variable "cato_secondary_bgp_default_action" {
  description = "Cato Secondary BGP Default Action"
  type        = string
  default     = "ACCEPT"
}

variable "cato_primary_bgp_metric" {
  description = "Cato Primary BGP Metric"
  type        = number
  default     = 100
}

variable "cato_secondary_bgp_metric" {
  description = "Cato Secondary BGP Metric"
  type        = number
  default     = 150
}

variable "cato_primary_bgp_advertise_all" {
  description = "Cato Primary BGP Advertise All"
  type        = bool
  default     = true
}

variable "cato_secondary_bgp_advertise_all" {
  description = "Cato Secondary BGP Advertise All"
  type        = bool
  default     = true
}

variable "cato_primary_bgp_advertise_default_route" {
  description = "Cato Primary BGP Advertise Default Route"
  type        = bool
  default     = false
}

variable "cato_secondary_bgp_advertise_default_route" {
  description = "Cato Secondary BGP Advertise Default Route"
  type        = bool
  default     = false
}

variable "cato_primary_bgp_advertise_summary_route" {
  description = "Cato Primary BGP Advertise Summary Route"
  type        = bool
  default     = false
}

variable "cato_secondary_bgp_advertise_summary_route" {
  description = "Cato Secondary BGP Advertise Summary Route"
  type        = bool
  default     = false
}

variable "cato_primary_bgp_bfd_transmit_interval" {
  description = "Cato Primary BGP BFD Transmit Interval"
  type        = number
  default     = 1000
}

variable "cato_secondary_bgp_bfd_transmit_interval" {
  description = "Cato Secondary BGP BFD Transmit Interval"
  type        = number
  default     = 1000
}

variable "cato_primary_bgp_bfd_receive_interval" {
  description = "Cato Primary BGP BFD Receive Interval"
  type        = number
  default     = 1000
}

variable "cato_secondary_bgp_bfd_receive_interval" {
  description = "Cato Secondary BGP BFD Receive Interval"
  type        = number
  default     = 1000
}

variable "cato_primary_bgp_bfd_multiplier" {
  description = "Cato Primary BGP BFD Multiplier"
  type        = number
  default     = 5
}

variable "cato_secondary_bgp_bfd_multiplier" {
  description = "Cato Secondary BGP BFD Multiplier"
  type        = number
  default     = 5
}

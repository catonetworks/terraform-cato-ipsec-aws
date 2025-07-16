# CATO IPSec AWS Terraform module

Terraform module which creates an IPsec site in the Cato Management Application (CMA), and a primary and secondary IPsec tunnel from AWS to the Cato platform.

## NOTE
- Site_Location is now generated dynamically based on AWS Region
- For help with finding exact sytax to match site location for city, state_name, country_name and timezone, please refer to the [cato_siteLocation data source](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/data-sources/siteLocation).
- For help with finding a license id to assign, please refer to the [cato_licensingInfo data source](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/data-sources/licensingInfo).
- Module does not support Policy Based Routes at this time, BGP is required. 

## Usage

```hcl

provider "aws" {
  region = var.region
}

provider "cato" {
  token = var.token
  account_id = var.account_id
  baseurl = var.baseurl
}

variable "region" {
  default = "us-east-2"
}

variable "token" {}
variable "account_id" {}
variable "baseurl" {}

module "ipsec-aws" {
  source = "catonetworks/ipsec-aws/cato"
  region                        = var.region
  aws_bgp_asn                   = 65000
  cato_bgp_asn                  = 65001
  vpc_id                       = "vpc-123abc" # Optional - Comment out and a VPC will be created for you
  site_name                     = "AWS-Cato-IPSec-Site"
  site_description              = "AWS Cato IPSec Site US-East-2"
  primary_public_cato_ip        = "x.x.x.x"
  secondary_public_cato_ip      = "y.y.y.y"
  native_network_range          = "10.10.16.0/20"

  #AWS Always takes the 1st IP in the Allocatied Subnet Range
  primary_vpn_tunnel1_inside_cidr = "169.254.10.0/30"
  primary_private_cato_ip   = "169.254.10.2"
  primary_private_site_ip   = "169.254.10.1"

  #AWS Always takes the 1st IP in the Allocatied Subnet Range
  secondary_vpn_tunnel1_inside_cidr = "169.254.20.0/30"
  secondary_private_cato_ip = "169.254.20.2"
  secondary_private_site_ip = "169.254.20.1"

  
  downstream_bw                 = 100
  upstream_bw                   = 100
  tags = { 
    example_tag = "example_value"
  }

}
```

## Site Location Reference

For more information on site_location syntax, use the [Cato CLI](https://github.com/catonetworks/cato-cli) to lookup values.

```bash
$ pip3 install catocli
$ export CATO_TOKEN="your-api-token-here"
$ export CATO_ACCOUNT_ID="your-account-id"
$ catocli query siteLocation -h
$ catocli query siteLocation '{"filters":[{"search": "San Diego","field":"city","operation":"exact"}]}' -p
```

## Authors

Module is maintained by [Cato Networks](https://github.com/catonetworks) with help from [these awesome contributors](https://github.com/catonetworks/terraform-cato-ipsec-aws/graphs/contributors).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/catonetworks/terraform-cato-ipsec-aws/tree/master/LICENSE) for full details.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_cato"></a> [cato](#requirement\_cato) | >= 0.0.30 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_cato"></a> [cato](#provider\_cato) | >= 0.0.30 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_customer_gateway.primary_customer_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/customer_gateway) | resource |
| [aws_customer_gateway.secondary_customer_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/customer_gateway) | resource |
| [aws_vpc.cato-vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpn_connection.primary_vpn_connection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_connection) | resource |
| [aws_vpn_connection.secondary_vpn_connection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_connection) | resource |
| [aws_vpn_gateway.vgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_gateway) | resource |
| [aws_vpn_gateway_attachment.vpn_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_gateway_attachment) | resource |
| [cato_bgp_peer.backup](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/resources/bgp_peer) | resource |
| [cato_bgp_peer.primary](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/resources/bgp_peer) | resource |
| [cato_ipsec_site.ipsec-site](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/resources/ipsec_site) | resource |
| [cato_license.license](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/resources/license) | resource |
| [cato_allocatedIp.primary](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/data-sources/allocatedIp) | data source |
| [cato_allocatedIp.secondary](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/data-sources/allocatedIp) | data source |
| [cato_siteLocation.site_location](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/data-sources/siteLocation) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_bgp_asn"></a> [aws\_bgp\_asn](#input\_aws\_bgp\_asn) | BGP ASN for the customer gateway | `number` | n/a | yes |
| <a name="input_cato_bgp_asn"></a> [cato\_bgp\_asn](#input\_cato\_bgp\_asn) | BGP ASN for the customer gateway | `number` | n/a | yes |
| <a name="input_cato_primary_bgp_advertise_all"></a> [cato\_primary\_bgp\_advertise\_all](#input\_cato\_primary\_bgp\_advertise\_all) | Cato Primary BGP Advertise All | `bool` | `true` | no |
| <a name="input_cato_primary_bgp_advertise_default_route"></a> [cato\_primary\_bgp\_advertise\_default\_route](#input\_cato\_primary\_bgp\_advertise\_default\_route) | Cato Primary BGP Advertise Default Route | `bool` | `false` | no |
| <a name="input_cato_primary_bgp_advertise_summary_route"></a> [cato\_primary\_bgp\_advertise\_summary\_route](#input\_cato\_primary\_bgp\_advertise\_summary\_route) | Cato Primary BGP Advertise Summary Route | `bool` | `false` | no |
| <a name="input_cato_primary_bgp_bfd_multiplier"></a> [cato\_primary\_bgp\_bfd\_multiplier](#input\_cato\_primary\_bgp\_bfd\_multiplier) | Cato Primary BGP BFD Multiplier | `number` | `5` | no |
| <a name="input_cato_primary_bgp_bfd_receive_interval"></a> [cato\_primary\_bgp\_bfd\_receive\_interval](#input\_cato\_primary\_bgp\_bfd\_receive\_interval) | Cato Primary BGP BFD Receive Interval | `number` | `1000` | no |
| <a name="input_cato_primary_bgp_bfd_transmit_interval"></a> [cato\_primary\_bgp\_bfd\_transmit\_interval](#input\_cato\_primary\_bgp\_bfd\_transmit\_interval) | Cato Primary BGP BFD Transmit Interval | `number` | `1000` | no |
| <a name="input_cato_primary_bgp_default_action"></a> [cato\_primary\_bgp\_default\_action](#input\_cato\_primary\_bgp\_default\_action) | Cato Primary BGP Default Action | `string` | `"ACCEPT"` | no |
| <a name="input_cato_primary_bgp_metric"></a> [cato\_primary\_bgp\_metric](#input\_cato\_primary\_bgp\_metric) | Cato Primary BGP Metric | `number` | `100` | no |
| <a name="input_cato_primary_bgp_peer_name"></a> [cato\_primary\_bgp\_peer\_name](#input\_cato\_primary\_bgp\_peer\_name) | Cato Primary BGP Peer Name | `string` | `null` | no |
| <a name="input_cato_secondary_bgp_advertise_all"></a> [cato\_secondary\_bgp\_advertise\_all](#input\_cato\_secondary\_bgp\_advertise\_all) | Cato Secondary BGP Advertise All | `bool` | `true` | no |
| <a name="input_cato_secondary_bgp_advertise_default_route"></a> [cato\_secondary\_bgp\_advertise\_default\_route](#input\_cato\_secondary\_bgp\_advertise\_default\_route) | Cato Secondary BGP Advertise Default Route | `bool` | `false` | no |
| <a name="input_cato_secondary_bgp_advertise_summary_route"></a> [cato\_secondary\_bgp\_advertise\_summary\_route](#input\_cato\_secondary\_bgp\_advertise\_summary\_route) | Cato Secondary BGP Advertise Summary Route | `bool` | `false` | no |
| <a name="input_cato_secondary_bgp_bfd_multiplier"></a> [cato\_secondary\_bgp\_bfd\_multiplier](#input\_cato\_secondary\_bgp\_bfd\_multiplier) | Cato Secondary BGP BFD Multiplier | `number` | `5` | no |
| <a name="input_cato_secondary_bgp_bfd_receive_interval"></a> [cato\_secondary\_bgp\_bfd\_receive\_interval](#input\_cato\_secondary\_bgp\_bfd\_receive\_interval) | Cato Secondary BGP BFD Receive Interval | `number` | `1000` | no |
| <a name="input_cato_secondary_bgp_bfd_transmit_interval"></a> [cato\_secondary\_bgp\_bfd\_transmit\_interval](#input\_cato\_secondary\_bgp\_bfd\_transmit\_interval) | Cato Secondary BGP BFD Transmit Interval | `number` | `1000` | no |
| <a name="input_cato_secondary_bgp_default_action"></a> [cato\_secondary\_bgp\_default\_action](#input\_cato\_secondary\_bgp\_default\_action) | Cato Secondary BGP Default Action | `string` | `"ACCEPT"` | no |
| <a name="input_cato_secondary_bgp_metric"></a> [cato\_secondary\_bgp\_metric](#input\_cato\_secondary\_bgp\_metric) | Cato Secondary BGP Metric | `number` | `150` | no |
| <a name="input_cato_secondary_bgp_peer_name"></a> [cato\_secondary\_bgp\_peer\_name](#input\_cato\_secondary\_bgp\_peer\_name) | Cato Secondary BGP Peer Name | `string` | `null` | no |
| <a name="input_downstream_bw"></a> [downstream\_bw](#input\_downstream\_bw) | Downstream bandwidth in Mbps | `number` | n/a | yes |
| <a name="input_license_bw"></a> [license\_bw](#input\_license\_bw) | The license bandwidth number for the cato site, specifying bandwidth ONLY applies for pooled licenses.  For a standard site license that is not pooled, leave this value null. Must be a number greater than 0 and an increment of 10. | `string` | `null` | no |
| <a name="input_license_id"></a> [license\_id](#input\_license\_id) | The license ID for the Cato vSocket of license type CATO\_SITE, CATO\_SSE\_SITE, CATO\_PB, CATO\_PB\_SSE.  Example License ID value: 'abcde123-abcd-1234-abcd-abcde1234567'.  Note that licenses are for commercial accounts, and not supported for trial accounts. | `string` | `null` | no |
| <a name="input_native_network_range"></a> [native\_network\_range](#input\_native\_network\_range) | Native network range for the IPSec site | `string` | n/a | yes |
| <a name="input_primary_destination_type"></a> [primary\_destination\_type](#input\_primary\_destination\_type) | The destination type of the IPsec tunnel | `string` | `null` | no |
| <a name="input_primary_pop_location_id"></a> [primary\_pop\_location\_id](#input\_primary\_pop\_location\_id) | Primary tunnel POP location ID | `string` | `null` | no |
| <a name="input_primary_private_cato_ip"></a> [primary\_private\_cato\_ip](#input\_primary\_private\_cato\_ip) | Private IP address of the Cato side for the primary tunnel | `string` | n/a | yes |
| <a name="input_primary_private_site_ip"></a> [primary\_private\_site\_ip](#input\_primary\_private\_site\_ip) | Private IP address of the site side for the primary tunnel | `string` | n/a | yes |
| <a name="input_primary_public_cato_ip"></a> [primary\_public\_cato\_ip](#input\_primary\_public\_cato\_ip) | Public IP address ID of the Cato side for the primary tunnel | `string` | n/a | yes |
| <a name="input_primary_vpn_tunnel1_inside_cidr"></a> [primary\_vpn\_tunnel1\_inside\_cidr](#input\_primary\_vpn\_tunnel1\_inside\_cidr) | Primary VPN, Tunnel 1 Inside CIDR | `string` | `"169.254.100.0/30"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region where resources will be deployed. | `string` | n/a | yes |
| <a name="input_secondary_destination_type"></a> [secondary\_destination\_type](#input\_secondary\_destination\_type) | The destination type of the IPsec tunnel | `string` | `null` | no |
| <a name="input_secondary_pop_location_id"></a> [secondary\_pop\_location\_id](#input\_secondary\_pop\_location\_id) | Secondary tunnel POP location ID | `string` | `null` | no |
| <a name="input_secondary_private_cato_ip"></a> [secondary\_private\_cato\_ip](#input\_secondary\_private\_cato\_ip) | Private IP address of the Cato side for the secondary tunnel | `string` | n/a | yes |
| <a name="input_secondary_private_site_ip"></a> [secondary\_private\_site\_ip](#input\_secondary\_private\_site\_ip) | Private IP address of the site side for the secondary tunnel | `string` | n/a | yes |
| <a name="input_secondary_public_cato_ip"></a> [secondary\_public\_cato\_ip](#input\_secondary\_public\_cato\_ip) | Public IP address ID of the Cato side for the secondary tunnel | `string` | n/a | yes |
| <a name="input_secondary_vpn_tunnel1_inside_cidr"></a> [secondary\_vpn\_tunnel1\_inside\_cidr](#input\_secondary\_vpn\_tunnel1\_inside\_cidr) | Primary VPN, Tunnel 2 Inside CIDR | `string` | `"169.254.200.0/30"` | no |
| <a name="input_site_description"></a> [site\_description](#input\_site\_description) | Description of the IPSec site | `string` | n/a | yes |
| <a name="input_site_location"></a> [site\_location](#input\_site\_location) | Site location which is used by the Cato Socket to connect to the closest Cato PoP. If not specified, the location will be derived from the Azure region dynamicaly. | <pre>object({<br/>    city         = string<br/>    country_code = string<br/>    state_code   = string<br/>    timezone     = string<br/>  })</pre> | <pre>{<br/>  "city": null,<br/>  "country_code": null,<br/>  "state_code": null,<br/>  "timezone": null<br/>}</pre> | no |
| <a name="input_site_name"></a> [site\_name](#input\_site\_name) | Name of the IPSec site | `string` | n/a | yes |
| <a name="input_site_type"></a> [site\_type](#input\_site\_type) | The type of the site | `string` | `"CLOUD_DC"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of Key-Value Tags | `map(any)` | `null` | no |
| <a name="input_upstream_bw"></a> [upstream\_bw](#input\_upstream\_bw) | Upstream bandwidth in Mbps | `number` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID where the VPN gateway will be attached | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cato_license_site"></a> [cato\_license\_site](#output\_cato\_license\_site) | n/a |
| <a name="output_primary_tunnel_address"></a> [primary\_tunnel\_address](#output\_primary\_tunnel\_address) | n/a |
| <a name="output_primary_vpn_connection_id"></a> [primary\_vpn\_connection\_id](#output\_primary\_vpn\_connection\_id) | ID of the created AWS VPN connection |
| <a name="output_secondary_tunnel_address"></a> [secondary\_tunnel\_address](#output\_secondary\_tunnel\_address) | n/a |
| <a name="output_secondary_vpn_connection_id"></a> [secondary\_vpn\_connection\_id](#output\_secondary\_vpn\_connection\_id) | ID of the created AWS VPN connection |
| <a name="output_site_id"></a> [site\_id](#output\_site\_id) | ID of the created Cato IPSec site |
| <a name="output_site_location"></a> [site\_location](#output\_site\_location) | n/a |
| <a name="output_tunnel1_preshared_key"></a> [tunnel1\_preshared\_key](#output\_tunnel1\_preshared\_key) | n/a |
| <a name="output_tunnel2_preshared_key"></a> [tunnel2\_preshared\_key](#output\_tunnel2\_preshared\_key) | n/a |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | ID of the created Cato IPSec site |
<!-- END_TF_DOCS -->
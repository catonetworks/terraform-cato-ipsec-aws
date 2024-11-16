# CATO IPSec AWS Terraform module

Terraform module which creates an IPsec site in the Cato Management Application (CMA), and a primary and secondary IPsec tunnel from AWS to the Cato platform.

## List of Resources:
- aws_customer_gateway
- aws_vpn_connection
- aws_vpn_gateway
- cato_ipsec_site (ipsec-site)
- cato_ipsec_site.ipsec_tunnel (primary)
- cato_ipsec_site.ipsec_tunnel (secondary)

## Usage

```hcl
provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = "10.10.16.0/20"
}

module "ipsec-aws" {
  source = "catonetworks/ipsec-aws/cato"
  token = "xxxxxxx"
  account_id = "xxxxxxx"
  region                        = "us-east-1"
  bgp_asn                       = 65000
  vpc_id                        = "vpc-123abc"
  cgw_ip                        = "11.22.33.44"
  site_name                     = "AWS-Cato-IPSec-Site"
  site_description              = "AWS Cato IPSec Site US-East-2"
  native_network_range          = "10.10.16.0/20"
  primary_public_cato_ip_id     = "31511"
  primary_private_cato_ip       = "169.1.1.1"
  primary_private_site_ip       = "169.1.1.2"
  secondary_public_cato_ip_id   = "31512"
  secondary_private_cato_ip     = "169.2.1.1"
  secondary_private_site_ip     = "169.2.1.2"
  downstream_bw                 = 100
  upstream_bw                   = 100
  site_location = {
    city         = "New York City"
    country_code = "US"
    state_code   = "US-NY" ## Optional - for countries with states"
    timezone     = "America/New_York"
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


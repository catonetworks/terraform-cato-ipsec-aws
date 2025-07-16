
# Only run this data block if var.site_location is null
# (Terraform does not support dynamic data blocks, so we use count)
data "cato_siteLocation" "site_location" {
  count = local.all_location_fields_null ? 1 : 0
  filters = concat([
    {
      field     = "city"
      operation = "exact"
      search    = local.region_to_location[local.locationstr].city
    },
    {
      field     = "country_name"
      operation = "exact"
      search    = local.region_to_location[local.locationstr].country
    }
    ],
    local.region_to_location[local.locationstr].state != null ? [
      {
        field     = "state_name"
        operation = "exact"
        search    = local.region_to_location[local.locationstr].state
      }
  ] : [])
}

locals {
  ## Check for all site_location inputs to be null
  all_location_fields_null = (
    var.site_location.city == null &&
    var.site_location.country_code == null &&
    var.site_location.state_code == null &&
    var.site_location.timezone == null
  ) ? true : false

  ## If all site_location fields are null, use the data source to fetch the 
  ## site_location from azure provuder location, else use var.site_location
  cur_site_location = local.all_location_fields_null ? {
    country_code = data.cato_siteLocation.site_location[0].locations[0].country_code
    timezone     = data.cato_siteLocation.site_location[0].locations[0].timezone[0]
    state_code   = data.cato_siteLocation.site_location[0].locations[0].state_code
    city         = data.cato_siteLocation.site_location[0].locations[0].city
  } : var.site_location

  locationstr = lower(replace(var.region, " ", ""))
  # Manual mapping of Azure regions to their cities and countries
  # Since Azure doesn't provide city/country in the API, we create our own mapping
  region_to_location = {
    # North America - United States
    "us-east-1"     = { city = "Ashburn", state = "Virginia", country = "United States", timezone = "UTC-5" }
    "us-east-2"     = { city = "Columbus", state = "Ohio", country = "United States", timezone = "UTC-5" }
    "us-west-1"     = { city = "San Francisco", state = "California", country = "United States", timezone = "UTC-8" }
    "us-west-2"     = { city = "Boardman", state = "Oregon", country = "United States", timezone = "UTC-8" }
    "us-gov-east-1" = { city = "Fairfax", state = "Virginia", country = "United States", timezone = "UTC-5" }
    "us-gov-west-1" = { city = "Boardman", state = "Oregon", country = "United States", timezone = "UTC-8" }

    # North America - Canada
    "ca-central-1" = { city = "Montréal", state = null, country = "Canada", timezone = "UTC-5" }
    "ca-west-1"    = { city = "Calgary", state = null, country = "Canada", timezone = "UTC-7" }

    # North America - Mexico
    "mx-central-1" = { city = "Austin", state = "Texas", country = "United States", timezone = "UTC-6" }

    # Europe
    "eu-central-1" = { city = "Frankfurt (Oder)", state = null, country = "Germany", timezone = "UTC+1" }
    "eu-central-2" = { city = "Zürich", state = null, country = "Switzerland", timezone = "UTC+1" }
    "eu-west-1"    = { city = "Dublin", state = null, country = "Ireland", timezone = "UTC+0" }
    "eu-west-2"    = { city = "London", state = null, country = "United Kingdom", timezone = "UTC+0" }
    "eu-west-3"    = { city = "Paris", state = null, country = "France", timezone = "UTC+1" }
    "eu-north-1"   = { city = "Stockholm", state = null, country = "Sweden", timezone = "UTC+1" }
    "eu-south-1"   = { city = "Milan", state = null, country = "Italy", timezone = "UTC+1" }
    "eu-south-2"   = { city = "Madrid", state = null, country = "Spain", timezone = "UTC+1" }

    # Asia Pacific
    "ap-east-1"      = { city = "Hong Kong", state = null, country = "Hong Kong", timezone = "UTC+8" }
    "ap-east-2"      = { city = "Taipei", state = null, country = "Taiwan", timezone = "UTC+8" }
    "ap-south-1"     = { city = "Mumbai", state = "Maharashtra", country = "India", timezone = "UTC+5:30" }
    "ap-south-2"     = { city = "Chennai", state = "Tamil Nadu", country = "India", timezone = "UTC+5:30" }
    "ap-northeast-1" = { city = "Tokyo", state = null, country = "Japan", timezone = "UTC+9" }
    "ap-northeast-2" = { city = "Seoul", state = null, country = "South Korea", timezone = "UTC+9" }
    "ap-northeast-3" = { city = "Osaka", state = null, country = "Japan", timezone = "UTC+9" }
    "ap-southeast-1" = { city = "Singapore", state = null, country = "Singapore", timezone = "UTC+8" }
    "ap-southeast-2" = { city = "Sydney", state = "New South Wales", country = "Australia", timezone = "UTC+10" }
    "ap-southeast-3" = { city = "Jakarta", state = null, country = "Indonesia", timezone = "UTC+7" }
    "ap-southeast-4" = { city = "Melbourne", state = "Victoria", country = "Australia", timezone = "UTC+10" }
    "ap-southeast-5" = { city = "Kuala Lumpur", state = null, country = "Malaysia", timezone = "UTC+8" }
    "ap-southeast-7" = { city = "Bangkok", state = null, country = "Thailand", timezone = "UTC+7" }

    # Middle East
    "me-south-1"   = { city = "Manama", state = null, country = "Bahrain", timezone = "UTC+3" }
    "me-central-1" = { city = "Dubai", state = null, country = "United Arab Emirates", timezone = "UTC+4" }
    "il-central-1" = { city = "Tel Aviv", state = null, country = "Israel", timezone = "UTC+2" }

    # Africa
    "af-south-1" = { city = "Cape Town", state = null, country = "South Africa", timezone = "UTC+2" }

    # South America
    "sa-east-1" = { city = "São Paulo", state = "São Paulo", country = "Brazil", timezone = "UTC-3" }

    # China (Isolated regions)
    "cn-north-1"     = { city = "Beijing", state = null, country = "China", timezone = "UTC+8" }
    "cn-northwest-1" = { city = "Beijing", state = null, country = "China", timezone = "UTC+8" }
  }
}

output "site_location" {
  value = data.cato_siteLocation.site_location
}

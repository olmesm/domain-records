terraform {
  experiments = [module_variable_optional_attrs]

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

variable "domain" {
  type        = string
  description = "domain name for DNS zone lookup"
}

variable "record_list" {
  type = map(object(
    {
      name     = string,
      value    = string,
      type     = string,
      priority = optional(string),
      proxied  = optional(bool),
      ttl      = optional(string),
    }
  ))
  description = "Collection of records indexed by a generated key."
}

data "cloudflare_zone" "main" {
  name = var.domain
}

resource "cloudflare_record" "default" {
  for_each = var.record_list

  zone_id  = data.cloudflare_zone.main.id
  name     = each.value["name"]
  value    = each.value["value"]
  type     = each.value["type"]
  priority = try(each.value["priority"], null)
  proxied  = try(each.value["proxied"], false)
  ttl      = try(each.value["ttl"], "1")
}

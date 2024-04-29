# variable "cloudflare_email" {
#   description = "TF_VAR_cloudflare_email"
#   type        = string
# }

variable "cloudflare_api_token" {
  description = "TF_VAR_cloudflare_api_token"
  type        = string
}

terraform {
  backend "gcs" {
    bucket = "domain-records"
    prefix = "terraform/cloudflare_state"
  }
}

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "cloudflare" {
  # email   = var.cloudflare_email
  api_token = var.cloudflare_api_token
}

locals {
  yaml_values = yamldecode(file("${path.module}/records.yaml"))

  map_list = {
    for domain, records in local.yaml_values : "${domain}" => {
      for record in records : "${substr(record.name, 0, 12)}-${md5("${record.name}-${record.value}")}" => record
    }
  }
}

module "cf_record_module" {
  source = "./modules/cf-module"

  for_each = local.map_list

  domain      = each.key
  record_list = each.value
}
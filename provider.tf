terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.85.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.1"
    }
    external = {
      source  = "hashicorp/external"
      version = ">= 2.3.1"
    }
  }
}

provider "yandex" {
  service_account_key_file = "./authorized_key.json"
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone_id
}
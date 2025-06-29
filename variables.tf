variable "folder_id" {
  description = "Default folder ID in yandex cloud"
  type        = string
  default     = "b1g4rg4nhsgl1hqptsjv"
}

variable "cloud_id" {
  description = "Default cloud ID in yandex cloud"
  type        = string
  default     = "b1geqfrr6fnicqpa7bnq"
}

variable "zone_id" {
  description = "Используемая зона размещения"
  type        = string
  default     = "ru-central1-d"
}

variable "ssh_user" {
  description = "SSH user for provisioning"
  type        = string
  default     = "ubuntu"
}

variable "ssh_private_key_path" {
  description = "Path to SSH private key"
  type        = string
  default     = "~/.ssh/id_rsa"
}
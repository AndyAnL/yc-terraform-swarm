# Образы ОС
data "yandex_compute_image" "ubuntu_22" {
  folder_id = "standard-images"
  family    = "ubuntu-2204-lts"  # Ubuntu 22.04 LTS
}
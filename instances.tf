resource "yandex_compute_instance" "swarm_manager" {
  name               = "swarm-manager"
  platform_id        = "standard-v3"
  zone               = var.zone_id
  service_account_id = data.yandex_iam_service_account.andyan_sa.id

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 50
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_22.id
      type     = "network-hdd"
      size     = 20
    }
  }

  network_interface {
    subnet_id      = yandex_vpc_subnet.swarm_subnet.id
    nat            = true
    nat_ip_address = yandex_vpc_address.swarm_public_ip.external_ipv4_address[0].address
    ip_address     = "192.168.10.10"
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file("${var.ssh_private_key_path}.pub")}"
  }
}

resource "yandex_compute_instance" "swarm_worker_1" {
  name        = "swarm-worker-1"
  platform_id = "standard-v3"
  zone        = var.zone_id
  service_account_id = data.yandex_iam_service_account.andyan_sa.id

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_22.id
      type     = "network-hdd"
      size     = 20
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.swarm_subnet.id
    nat        = true
    ip_address = "192.168.10.11"
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file("${var.ssh_private_key_path}.pub")}"
  }
}

resource "yandex_compute_instance" "swarm_worker_2" {
  name        = "swarm-worker-2"
  platform_id = "standard-v3"
  zone        = var.zone_id
  service_account_id = data.yandex_iam_service_account.andyan_sa.id

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_22.id
      type     = "network-hdd"
      size     = 20
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.swarm_subnet.id
    nat        = true
    ip_address = "192.168.10.12"
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file("${var.ssh_private_key_path}.pub")}"
  }
}
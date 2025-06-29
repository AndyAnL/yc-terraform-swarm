resource "yandex_vpc_network" "swarm_network" {
  name        = "swarm-network"
  description = "Network for Docker Swarm cluster"
}

resource "yandex_vpc_subnet" "swarm_subnet" {
  name           = "swarm-subnet"
  description    = "Subnet for Docker Swarm in ru-central1-d"
  zone           = var.zone_id
  network_id     = yandex_vpc_network.swarm_network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_address" "swarm_public_ip" {
  name = "swarm-public-ip"
  
  external_ipv4_address {
    zone_id = var.zone_id
  }
}
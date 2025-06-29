output "manager_public_ip" {
  value       = yandex_compute_instance.swarm_manager.network_interface.0.nat_ip_address
  description = "Публичный IP-адрес manager-ноды"
}

output "workers_public_ips" {
  value = {
    worker1 = yandex_compute_instance.swarm_worker_1.network_interface.0.nat_ip_address
    worker2 = yandex_compute_instance.swarm_worker_2.network_interface.0.nat_ip_address
  }
  description = "Публичные IP-адреса worker-нод"
}

output "swarm_services" {
  value = {
    web_ui = "http://${yandex_compute_instance.swarm_manager.network_interface.0.nat_ip_address}"
  }
  description = "URL приложения"
}
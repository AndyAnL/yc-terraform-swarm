resource "null_resource" "provision_manager" {
  triggers = {
    instance_id = yandex_compute_instance.swarm_manager.id
  }

  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = file(var.ssh_private_key_path)
    host        = yandex_compute_instance.swarm_manager.network_interface.0.nat_ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -qq",
      "sudo apt-get install -y docker.io",
      "sudo systemctl enable docker",
      "sudo docker swarm init --advertise-addr ${yandex_compute_instance.swarm_manager.network_interface.0.ip_address}",
      "sudo docker swarm join-token -q worker > /tmp/swarm_token",
      "chmod 644 /tmp/swarm_token"
    ]
  }
}

resource "null_resource" "provision_workers" {
  for_each = {
    worker1 = yandex_compute_instance.swarm_worker_1,
    worker2 = yandex_compute_instance.swarm_worker_2
  }

  triggers = {
    instance_id = each.value.id
  }

  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = file(var.ssh_private_key_path)
    host        = each.value.network_interface.0.nat_ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -qq",
      "sudo apt-get install -y docker.io",
      "sudo systemctl enable docker"
    ]
  }

  depends_on = [null_resource.provision_manager]
}

resource "null_resource" "join_workers" {
  for_each = {
    worker1 = yandex_compute_instance.swarm_worker_1,
    worker2 = yandex_compute_instance.swarm_worker_2
  }

  triggers = {
    worker_id   = each.value.id
    manager_ip = yandex_compute_instance.swarm_manager.network_interface.0.ip_address
  }

  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = file(var.ssh_private_key_path)
    host        = each.value.network_interface.0.nat_ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "sudo docker swarm join --token ${trimspace(data.external.swarm_token.result.token)} ${yandex_compute_instance.swarm_manager.network_interface.0.ip_address}:2377"
    ]
  }

  depends_on = [
    null_resource.provision_manager,
    null_resource.provision_workers
  ]
}

data "external" "swarm_token" {
  program = ["bash", "-c", <<EOT
    ssh -i ${var.ssh_private_key_path} -o StrictHostKeyChecking=no ${var.ssh_user}@${yandex_compute_instance.swarm_manager.network_interface.0.nat_ip_address} "sudo docker swarm join-token -q worker" | awk '{print "{\"token\":\""$0"\"}"}'
  EOT
  ]

  depends_on = [null_resource.provision_manager]
}

resource "null_resource" "deploy_stack" {
  triggers = {
    manager_ip = yandex_compute_instance.swarm_manager.network_interface.0.nat_ip_address
  }

  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = file(var.ssh_private_key_path)
    host        = yandex_compute_instance.swarm_manager.network_interface.0.nat_ip_address
  }

  provisioner "file" {
    source      = "docker-compose-v3.yml"
    destination = "/tmp/docker-compose.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo docker stack deploy --compose-file /tmp/docker-compose.yml sockshop",
      "sudo docker service scale sockshop_front-end=2"
    ]
  }

  depends_on = [
    null_resource.join_workers
  ]
}
output "nodes_external_ip" {
  value = yandex_compute_instance.swarm-node[*].network_interface[0].nat_ip_address
}
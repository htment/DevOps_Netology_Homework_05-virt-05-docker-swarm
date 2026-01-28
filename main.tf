

resource "yandex_vpc_network" "swarm-network" {
  name = "swarm-network"
}

resource "yandex_vpc_subnet" "swarm-subnet" {
  name           = "swarm-subnet"
  network_id     = yandex_vpc_network.swarm-network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = var.yandex_zone
}

resource "yandex_compute_instance" "swarm-node" {
  count = 3
  
  name        = "swarm-node-${count.index}"
  hostname    = "swarm-node-${count.index}"
  platform_id = "standard-v3"
  zone        = var.yandex_zone
  
  resources {
    cores  = 2
    memory = 1
    core_fraction = 20
  }
  
  boot_disk {
    initialize_params {
      image_id = "fd8995uqr5belqskff7j"
      size     = 10
    }
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.swarm-subnet.id
    nat       = true
  }

  scheduling_policy {
    preemptible = true
  }

# Настроим подключение по ssh
  metadata = {
    ssh-keys = "art:${file("~/.ssh/id_rsa.pub")}"
    user-data          = file("./cloud-init.yml")
  }
  
# connection {
#    type        = "ssh"
#    user        = var.vm_user
#    private_key = file(replace(var.ssh_public_key_path, ".pub", ""))
#    host        = self.network_interface[0].nat_ip_address
#  }
#  
#  provisioner "remote-exec" {
#    inline = [
#      "sudo apt-get update",
#      "sudo apt-get install -y python3"
#    ]
#  }



}
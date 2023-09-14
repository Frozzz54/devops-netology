resource "yandex_compute_instance" "node1" {
  name                      = "node1"
  zone                      = "ru-central1-a"
  hostname                  = "node1.netology.cloud"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu-2204-lts
      name     = "system-node1"
      type     = "network-nvme"
      size     = "20"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = true
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}
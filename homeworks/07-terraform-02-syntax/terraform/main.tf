provider "yandex" {
  service_account_key_file = "key.json"
}

resource "yandex_compute_instance" "node01" {
  name = "node01"
  zone = "ru-central1-a"

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8hbaoni28r5s8vndl9"
    }
  }


  network_interface {
    subnet_id = "${yandex_vpc_subnet.default.id}"
    nat       = true
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}
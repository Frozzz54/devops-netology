provider "yandex" {
  service_account_key_file = "key.json"
}

resource "yandex_compute_instance" "vm" {
  name = "terraform_vm"

  resources {
    cores  = 4
    memory = 4
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.default.id}"
    nat       = true
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}
# Заменить на ID своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_cloud_id" {
  default = "b1gef0jl0aa6n1eiac0n"
}

# Заменить на Folder своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_folder_id" {
  default = "b1g4gs6pra6ndk9uvvc4"
}

# Заменить на ID своего образа
# ID можно узнать с помощью команды yc compute image list
variable "centos-8-base" {
  default = "fd8151sv1q69mchl804a"
}
variable "centos-7-base" {
  default = "fd8jvcoeij6u9se84dt5"
}
variable "ubuntu-2204-lts" {
  default = "fd8ebb4u1u8mc6fheog1"
}
variable "ubuntu-2004-lts" {
  default = "fd852pbtueis1q0pbt4o"
}

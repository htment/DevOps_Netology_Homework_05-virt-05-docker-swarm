variable "yandex_cloud_id" {}
variable "yandex_folder_id" {}
variable "yandex_zone" {
  default = "ru-central1-a"
}

variable "ssh_public_key" {
  description = "SSH public key for user art"
  type        = string
}


# variable "vm_count" {
#  default = 3
#}
#variable "vm_image_id" {
#  default = "fd8a8r3qo1n7ehf6u3rk"
#}
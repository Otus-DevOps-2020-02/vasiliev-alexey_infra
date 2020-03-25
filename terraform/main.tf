terraform {
  # Версия terraform
  required_version = "~> 0.12.8"
}

provider "google" {
  # Версия провайдера
  version = "~> 2.15"

  # ID проекта
  project = "infra-271017"

  region = "europe-west-1"
}
resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = "europe-west1-b"
  boot_disk {
    initialize_params {
      image = "reddit-base"
    }
  }

  metadata = {
    # путь до публичного ключа
    ssh-keys = "appuser:${file("~/.ssh/appuser.pub")}"
  }

  network_interface {
    network = "default"
    access_config {}
  }
}

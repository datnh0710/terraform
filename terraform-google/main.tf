provider "google" {
    project = var.project
    region  = var.region
    zone =  var.zone
}

resource "google_compute_network" "vpc_network" {
  name                    = var.network_name
  auto_create_subnetworks = false
  
}

resource "google_compute_instance" "vm_instance" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  tags = var.tags

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name

    access_config {
    }
  }
  
}
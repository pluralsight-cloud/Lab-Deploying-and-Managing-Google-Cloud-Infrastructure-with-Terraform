terraform {
  required_version = ">= 1.6.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  # TODO 1: Set your GCP project ID
  project = ""

  region = "us-central1"

  # TODO 2: Set your GCP zone, for example "us-central1-a"
  zone = ""
}

resource "google_compute_network" "tf_vpc" {
  name                    = "terraform-secondary-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "tf_subnet" {
  name          = "terraform-secondary-subnet"
  ip_cidr_range = "10.20.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.tf_vpc.id
}

resource "google_compute_address" "tf_public_ip" {
  name   = "terraform-secondary-public-ip"
  region = "us-central1"
}

resource "google_compute_firewall" "tf_allow_ssh" {
  name    = "terraform-secondary-allow-ssh"
  network = google_compute_network.tf_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-ssh"]
}

resource "google_compute_instance" "tf_vm" {
  # TODO 3: Give the VM a unique name
  name = ""

  machine_type = "e2-micro"

  tags = ["allow-ssh"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.tf_subnet.id

    access_config {
      nat_ip = google_compute_address.tf_public_ip.address
    }
  }

  metadata = {
    startup-script = <<-EOT
      #!/bin/bash
      sudo apt-get update
    EOT
  }

  labels = {
    environment = "lab"
    managed_by  = "terraform"
  }
}

output "public_ip_address" {
  description = "Public IP address of the Terraform-created VM"
  value       = google_compute_address.tf_public_ip.address
}

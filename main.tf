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

resource "google_storage_bucket" "tf_bucket" {
  # TODO 3: Give the bucket a globally unique name
  name = ""

  location = "US"

  storage_class = "STANDARD"

  uniform_bucket_level_access = true

  labels = {
    environment = "lab"
    managed_by  = "terraform"
  }
}

output "bucket_name" {
  description = "Name of the Terraform-created Cloud Storage bucket"
  value       = google_storage_bucket.tf_bucket.name
}

output "bucket_url" {
  description = "URL of the Terraform-created Cloud Storage bucket"
  value       = google_storage_bucket.tf_bucket.url
}

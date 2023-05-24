terraform {
  required_version = ">= 1.4.6"
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.64.0"
    }
  }
  backend "gcs" {
      bucket = "gcptfstate"
      prefix = "terraform/dev"
#      credentials = file("key.json")
  }
}

provider "google" {
#  credentials = file("key.json")

  project = "playground-s-11-3d9058a1"
  region  = "us-central1"
  zone    = "us-central1-c"
}
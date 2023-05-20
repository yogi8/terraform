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
  }
}

provider "google" {
  credentials = file("<NAME>.json")

  project = "<PROJECT_ID>"
  region  = "us-central1"
  zone    = "us-central1-c"
}
terraform {
  required_version = ">= 1.4.6"
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.64.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
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

data "google_client_config" "provider" {}

provider "helm" {
  registry_config_path = abspath("~/.docker.config.json")
  kubernetes {
    host  = "https://${google_container_cluster.cluster.endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
      google_container_cluster.cluster.master_auth[0].cluster_ca_certificate
    )
  }
}

provider "docker" {
  registry_auth {
    address = "${var.repository_region}-docker.pkg.dev"
  }
}

data "google_project" "project" {}

# module "gke_auth" {
#   source = "terraform-google-modules/kubernetes-engine/google//modules/auth"
#   version = "24.1.0"
#   depends_on   = [module.gke]
#   project_id   = var.project_id
#   location     = module.gke.location
#   cluster_name = module.gke.name
# }

# resource "local_file" "kubeconfig" {
#   content  = module.gke_auth.kubeconfig_raw
#   filename = "kubeconfig-${var.env_name}"
# }
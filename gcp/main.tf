resource "google_container_cluster" "cluster" {
  name     = var.name
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1
}
resource "google_container_node_pool" "nodes" {
  name       = "${var.name}-nodes"
  location   = var.region
  cluster    = google_container_cluster.cluster.name
  node_count = var.node_count

  node_config {
    machine_type = var.machine_type
#    preemptible  = true
#    service_account = google_service_account.default.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]
    labels = {
      env = "gcp-gke-telecom"
    }
    tags         = ["gke-node", "gcp-gke-tele"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
output "cluster_name" {
  value = google_container_cluster.cluster.name
}
output "endpoint" {
    value = google_container_cluster.cluster.endpoint
}
output "ca_cert" {
  value = google_container_cluster.cluster.master_auth[0].cluster_ca_certificate
}
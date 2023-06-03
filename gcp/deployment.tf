resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress-controller"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"

  set {
    name  = "service.type"
    value = "ClusterIP"
  }
}



# resource "google_kms_key_ring" "keyring" {
#   name     = "keyring-example"
#   location = var.region
# }

# resource "google_kms_crypto_key" "example-key" {
#   name            = "crypto-key-example"
#   key_ring        = google_kms_key_ring.keyring.id
#   rotation_period = "100000s"

# #  lifecycle {
# #    prevent_destroy = true
# #  }
# }


resource "google_artifact_registry_repository" "my-repo" {
  location      = var.region
  repository_id = "dock"
  description   = "example docker repository"
  format        = "DOCKER"
  # kms_key_name  = google_kms_crypto_key.example-key.id
}

resource "null_resource" "readcontentfile" {
  provisioner "local-exec" {
   command = "Get-Content -Path ../mytextfile.txt"
   interpreter = ["PowerShell", "-Command"]
  }
}

resource "helm_release" "nginx" {
  name       = "nginx"

  repository = "oci://us-central1-docker.pkg.dev/playground-s-11-393dfc07/dock"
  chart      = "nginx"

  set {
    name  = "service.type"
    value = "ClusterIP"
  }
}

output "cheese" {
  value = google_artifact_registry_repository.my-repo
}
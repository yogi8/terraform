#working
# resource "helm_release" "nginx_ingress" {
#   name       = "nginx-ingress-controller"

#   repository = "https://charts.bitnami.com/bitnami"
#   chart      = "nginx-ingress-controller"

#   set {
#     name  = "service.type"
#     value = "ClusterIP"
#   }
# }


#not required
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
  location      = var.repository_region
  repository_id = "dock"
  description   = "example docker repository"
  format        = "DOCKER"
}

# resource "null_resource" "readcontentfile" {
#   provisioner "local-exec" {
#     command = "gcloud auth configure-docker ${var.repository_region}-docker.pkg.dev --quiet && helm push nginx-15.0.1.tgz oci://${var.repository_region}-docker.pkg.dev/${data.google_project.project.name}/${var.repository}"
#   }
# }

# data "template_file" "init" {
#   template = file("${path.module}/init.tpl")
#   vars = {
#     repo_name = "${var.repository_region}"
#   }
# }

#can be checked with pre execution of 'gcloud auth configure-docker us-central1-docker.pkg.dev'
#where helm registry key is given 'registry_config_path' to custom path like below is not working
# resource "helm_release" "nginx" {
#   name       = "nginx"

#   repository = "oci://${var.repository_region}-docker.pkg.dev/${data.google_project.project.name}/${var.repository}"
#   chart      = "nginx"

#   set {
#     name  = "service.type"
#     value = "ClusterIP"
#   }
# }

resource "helm_release" "example" {
  name       = "my-local-chart"
  chart      = "./charts/example"
}

output "cheese" {
  value = google_artifact_registry_repository.my-repo
}
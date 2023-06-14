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

resource "null_resource" "readcontentfile" {
  provisioner "local-exec" {
    command = "helm push nginx-15.0.1.tgz oci://${var.repository_region}-docker.pkg.dev/${data.google_project.project.name}/${var.repository}/chart"
  }
  depends_on = [google_artifact_registry_repository.my-repo]
}

resource "docker_registry_image" "helloworld" {
  name          = docker_image.image.name
  keep_remotely = true
}

resource "docker_image" "image" {
  name = "${var.repository_region}-docker.pkg.dev/${data.google_project.project.name}/${var.repository}/image/nginx"
  build {
    context = "${path.cwd}/build/nginx"
  }
}

# data "template_file" "init" {
#   template = file("${path.module}/init.tpl")
#   vars = {
#     repo_name = "${var.repository_region}"
#   }
# }

#can be checked with pre execution of 'gcloud auth configure-docker us-central1-docker.pkg.dev'
#where helm registry key is given 'registry_config_path' to custom path like below is not working
resource "helm_release" "nginx" {
  name       = "nginx"

  repository = "oci://${var.repository_region}-docker.pkg.dev/${data.google_project.project.name}/${var.repository}/chart"
  chart      = "nginx"

  set {
    name  = "image.registry"
    value = "${var.repository_region}-docker.pkg.dev"
  }

  set {
    name  = "image.repository"
    value = "${data.google_project.project.name}/${var.repository}/image/nginx"
  }

  set {
    name  = "containerPorts.http"
    value = "80"
  }

  set {
    name  = "image.tag"
    value = "latest"
  }
}

# resource "helm_release" "example" {
#   name       = "my-local-chart"
#   chart      = "./charts/example"
# }

output "cheese" {
  value = google_artifact_registry_repository.my-repo
}
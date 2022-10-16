resource "google_cloud_run_service" "crs" {
  name = "${var.project_unique_id}-crs"
  location = var.gcp_default_region
  template {
    spec {
      containers {
        image = "gcr.io/cloudrun/hello"
        resources {
          limits = {
            "cpu" = 1
            "memory" = "128Mi"
          }
        }
      }
    }
    metadata {
      annotations = {
        "autscaling.knative.dev/maxScale" = 1
      }
    }
  }
  depends_on = [
    google_project_service.services
  ]
}
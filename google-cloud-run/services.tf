resource "google_project_service" "services" {
  project = var.gcp_project_id
  for_each =  toset([
    "cloudresourcemanager",
    "run",
  ])
  service = "${each.key}.googleapis.com"
  disable_on_destroy = false
}
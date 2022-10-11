resource "google_compute_subnetwork" "vms" {
  name          = "${var.project_unique_id}-vms"
  ip_cidr_range = "10.0.3.0/24"
  region        = var.gcp_default_region
  network       = google_compute_network.main.id
}

resource "google_compute_network" "main" {
  name                    = "${var.project_unique_id}-main"
  auto_create_subnetworks = false
}
resource "google_compute_instance" "vm-1" {
  name         = "vm-1"
  machine_type = "e2-micro"
  zone         = "${var.gcp_default_region}-a"
  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.vms.id
    access_config {
      nat_ip = google_compute_address.vm-1.address
    }
  }
  metadata = {
    "ssh-keys"               = format("ubuntu:%s", file("~/.ssh/id_rsa.pub"))
    "block-project-ssh-keys" = true
  }
  tags = [var.firewall_tags.firewall-ingress-allow-from-allowed-list]
}

data "google_compute_image" "ubuntu" {
  family  = "ubuntu-2204-lts"
  project = "ubuntu-os-cloud"
}
resource "google_compute_address" "vm-1" {
  name = "vm-1"
}
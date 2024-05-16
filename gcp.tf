data "google_compute_image" "debian" {
  family  = "debian-12"
  project = "debian-cloud"
}

resource "google_compute_instance" "free-instance-20240515-163538" {
  boot_disk {
    auto_delete = true
    device_name = var.gcp_device_name

    initialize_params {
      image = data.google_compute_image.debian.self_link
      size  = var.gcp_memory_in_gbs
      type  = var.gcp_memory_type
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = true
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  machine_type = var.gcp_vm_device_type
  name         = var.gcp_instance_name

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = var.gcp_subnet_work
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = var.gcp_service_account_email
    scopes = var.gcp_service_account_scopes
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  metadata = {
    ssh-keys = var.gcp_ssh_public_keys
  }

  zone = var.gcp_zone
}

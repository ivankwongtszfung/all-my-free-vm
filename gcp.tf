data "google_compute_image" "debian" {
  family  = "debian-12"
  project = "debian-cloud"
}

resource "google_compute_instance" "free-instance-20240515-163538" {
  boot_disk {
    auto_delete = true
    device_name = "instance-20240515-163538"

    initialize_params {
      image = data.google_compute_image.debian.self_link
      size  = var.gcp_memory_in_gbs
      type  = "pd-standard"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = true
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  machine_type = "e2-micro"
  name         = "free-instance-20240515-163538"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/api-auth-service-423317/regions/us-west1/subnetworks/default"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = "350161083825-compute@developer.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
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

output "gcp_instance_name" {
  description = "The name of the created instance"
  value       = google_compute_instance.free-instance-20240515-163538.name
}

output "gcp_instance_zone" {
  description = "The zone where the instance is deployed"
  value       = google_compute_instance.free-instance-20240515-163538.zone
}

output "gcp_instance_self_link" {
  description = "The self-link of the created instance"
  value       = google_compute_instance.free-instance-20240515-163538.self_link
}

output "gcp_instance_network_interface" {
  description = "The network interface details of the created instance"
  value       = google_compute_instance.free-instance-20240515-163538.network_interface
}

output "gcp_instance_external_ip" {
  description = "The external IP address of the created instance"
  value       = google_compute_instance.free-instance-20240515-163538.network_interface[0].access_config[0].nat_ip
}

output "gcp_instance_internal_ip" {
  description = "The internal IP address of the created instance"
  value       = google_compute_instance.free-instance-20240515-163538.network_interface[0].network_ip
}

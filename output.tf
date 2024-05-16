
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

output "oci_instance_private_ips" {
  value = [oci_core_instance.atlas_instance.*.private_ip]
}

output "oci_instance_public_ips" {
  value = [oci_core_instance.atlas_instance.*.public_ip]
}

output "oci_boot_volume_ids" {
  value = [oci_core_instance.atlas_instance.*.boot_volume_id]
}

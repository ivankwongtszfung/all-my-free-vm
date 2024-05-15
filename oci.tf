resource "oci_core_instance" "atlas_instance" {
  count               = var.oci_num_instances
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.oci_compartment_ocid
  display_name        = format("%s${count.index}", replace(title(var.oci_instance_name), "/\\s/", ""))
  shape               = var.oci_instance_shape

  shape_config {
    ocpus         = var.oci_instance_ocpus
    memory_in_gbs = var.oci_instance_shape_config_memory_in_gbs
  }

  create_vnic_details {
    subnet_id                 = oci_core_subnet.atlas_subnet.id
    display_name              = format("%sVNIC", replace(title(var.oci_instance_name), "/\\s/", ""))
    assign_public_ip          = true
    assign_private_dns_record = true
    hostname_label            = format("%s${count.index}", lower(replace(var.oci_instance_name, "/\\s/", "")))
  }

  source_details {
    source_type             = var.oci_instance_source_type
    source_id               = var.oci_instance_image_ocid
    boot_volume_size_in_gbs = var.oci_boot_volume_size_in_gbs
  }

  metadata = {
    ssh_authorized_keys = var.oci_ssh_public_keys
  }

  timeouts {
    create = "60m"
  }
}

data "oci_core_instance_devices" "atlas_instance_devices" {
  count       = var.oci_num_instances
  instance_id = oci_core_instance.atlas_instance[count.index].id
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

output "oci_instance_devices" {
  value = [data.oci_core_instance_devices.atlas_instance_devices.*.devices]
}

resource "oci_core_vcn" "atlas_vcn" {
  cidr_block     = "10.1.0.0/16"
  compartment_id = var.oci_compartment_ocid
  display_name   = format("%sVCN", replace(title(var.oci_instance_name), "/\\s/", ""))
  dns_label      = format("%svcn", lower(replace(var.oci_instance_name, "/\\s/", "")))
}

resource "oci_core_security_list" "atlas_security_list" {
  compartment_id = var.oci_compartment_ocid
  vcn_id         = oci_core_vcn.atlas_vcn.id
  display_name   = format("%sSecurityList", replace(title(var.oci_instance_name), "/\\s/", ""))

  # Allow outbound traffic on all ports for all protocols
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
    stateless   = false
  }

  # Allow inbound traffic on all ports for all protocols
  ingress_security_rules {
    protocol  = "all"
    source    = "0.0.0.0/0"
    stateless = false
  }

  # Allow inbound icmp traffic of a specific type
  ingress_security_rules {
    protocol  = 1
    source    = "0.0.0.0/0"
    stateless = false

    icmp_options {
      type = 3
      code = 4
    }
  }
}

resource "oci_core_internet_gateway" "atlas_internet_gateway" {
  compartment_id = var.oci_compartment_ocid
  display_name   = format("%sIGW", replace(title(var.oci_instance_name), "/\\s/", ""))
  vcn_id         = oci_core_vcn.atlas_vcn.id
}

resource "oci_core_default_route_table" "default_route_table" {
  manage_default_resource_id = oci_core_vcn.atlas_vcn.default_route_table_id
  display_name               = "DefaultRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.atlas_internet_gateway.id
  }
}

resource "oci_core_subnet" "atlas_subnet" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  cidr_block          = "10.1.20.0/24"
  display_name        = format("%sSubnet", replace(title(var.oci_instance_name), "/\\s/", ""))
  dns_label           = format("%ssubnet", lower(replace(var.oci_instance_name, "/\\s/", "")))
  security_list_ids   = [oci_core_security_list.atlas_security_list.id]
  compartment_id      = var.oci_compartment_ocid
  vcn_id              = oci_core_vcn.atlas_vcn.id
  route_table_id      = oci_core_vcn.atlas_vcn.default_route_table_id
  dhcp_options_id     = oci_core_vcn.atlas_vcn.default_dhcp_options_id
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.oci_tenancy_ocid
  ad_number      = var.oci_availability_domain
}

resource "null_resource" "remote-exec" {
  count = var.oci_auto_iptables ? var.oci_num_instances : 0

  connection {
    agent       = false
    timeout     = "30m"
    host        = element(oci_core_instance.atlas_instance.*.public_ip, count.index)
    user        = "ubuntu"
    private_key = file(var.oci_ssh_private_key)
  }

  provisioner "remote-exec" {
    inline = [
      "export DATE=$(date +%Y%m%d); sudo iptables -L > \"/home/ubuntu/iptables-$DATE.bak\"",
      "sudo sh -c 'iptables -D INPUT -j REJECT --reject-with icmp-host-prohibited 2> /dev/null; iptables-save > /etc/iptables/rules.v4;'",
      "sudo sh -c 'iptables -D FORWARD -j REJECT --reject-with icmp-host-prohibited 2> /dev/null; iptables-save > /etc/iptables/rules.v4;'",
    ]
  }
}

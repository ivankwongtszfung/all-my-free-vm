################################################################################################
#                                     Oracle Cloud Parameter 
################################################################################################
variable "oci_fingerprint" {
  description = "Fingerprint of oci api private key"
  type        = string
}

variable "oci_private_key_path" {
  description = "Path to oci api private key used"
  type        = string
}

variable "oci_region" {
  description = "The oci region where resources will be created"
  type        = string
}

variable "oci_tenancy_ocid" {
  description = "Tenancy ocid where to create the sources"
  type        = string
}

variable "oci_user_ocid" {
  description = "Ocid of user that terraform will use to create the resources"
  type        = string
}

variable "oci_compartment_ocid" {
  description = "Compartment ocid where to create all resources"
  type        = string
}

variable "oci_instance_name" {
  description = "Name of the instance."
  type        = string
}

variable "oci_instance_ad_number" {
  default     = 1
  description = "The availability domain number of the instance. If none is provided, it will start with AD-1 and continue in round-robin."
  type        = number
}

variable "oci_instance_count" {
  default     = 1
  description = "Number of identical instances to launch from a single module."
  type        = number
}

variable "oci_instance_state" {
  default     = "RUNNING"
  description = "(Updatable) The target state for the instance. Could be set to RUNNING or STOPPED."
  type        = string

  validation {
    condition     = contains(["RUNNING", "STOPPED"], var.oci_instance_state)
    error_message = "Accepted values are RUNNING or STOPPED."
  }
}

variable "oci_ssh_public_keys" {
  default     = null
  description = "Public SSH keys to be included in the ~/.ssh/authorized_keys file for the default user on the instance. To provide multiple keys, see docs/instance_ssh_keys.adoc."
  type        = string
}

variable "oci_ssh_private_key" {
  default     = null
  description = "Private SSH key for remote execution."
  type        = string
}

variable "oci_auto_iptables" {
  default     = false
  description = "Automatically configure iptables to allow inbound traffic."
  type        = bool
}

variable "oci_assign_public_ip" {
  default     = false
  description = "Whether the VNIC should be assigned a public IP address."
  type        = bool
}

variable "oci_public_ip" {
  default     = "NONE"
  description = "Whether to create a Public IP to attach to primary vnic and which lifetime. Valid values are NONE, RESERVED or EPHEMERAL."
  type        = string
}

variable "oci_num_instances" {
  default = "1"
}

variable "oci_availability_domain" {
  default     = 3
  description = "Availability Domain of the instance"
  type        = number
}

variable "oci_instance_shape" {
  default     = "VM.Standard.A1.Flex"
  description = "The shape of an instance."
  type        = string
}

variable "oci_instance_ocpus" {
  default     = 1
  description = "Number of OCPUs"
  type        = number
}

variable "oci_instance_shape_config_memory_in_gbs" {
  default     = 6
  description = "Amount of Memory (GB)"
  type        = number
}

variable "oci_instance_source_type" {
  default     = "image"
  description = "The source type for the instance."
  type        = string
}

variable "oci_boot_volume_size_in_gbs" {
  default     = "50"
  description = "Boot volume size in GBs"
  type        = number
}

variable "oci_instance_image_ocid" {
  type        = string
  default     = "ocid1.image.oc1.ca-toronto-1.aaaaaaaa5zpkh5zev23zq5veisztq7slcu7gfts4otmgtanry5iqfe777kvq"
  description = "image id for toronto region"
}

################################################################################################
#                                     Google Cloud Parameter 
################################################################################################
variable "gcp_project_id" {
  type        = string
  description = "The name of your google-cloud project id"
}

variable "gcp_project" {
  type        = string
  description = "The name of your google-cloud project, e.g. 'free-micro-123456'"
}

variable "gcp_region" {
  type    = string
  default = "us-west1"
}

variable "gcp_zone" {
  type    = string
  default = "us-west1-c"
}

variable "gcp_memory_in_gbs" {
  default     = 30
  description = "volume size in GBs"
  type        = number
}

variable "gcp_ssh_public_keys" {
  description = "Public SSH keys to be included in the ~/.ssh/authorized_keys file for the default user on the instance. To provide multiple keys, see docs/instance_ssh_keys.adoc."
  type        = string
}

variable "gcp_device_name" {
  type        = string
  description = "name of your device"
}

variable "gcp_memory_type" {
  type        = string
  description = "memory type of the gcp, for free tier pd-standard"
  default     = "pd-standard"
}

variable "gcp_vm_device_type" {
  type        = string
  description = "the device type of your gcp instance, for free tier e2-micro"
  default     = "e2-micro"
}

variable "gcp_instance_name" {
  type        = string
  description = "name of your gcp instance"
}

variable "gcp_subnet_work" {
  type        = string
  description = "the path to your subnetwork check your default path in gcp"
  default     = "projects/api-auth-service-423317/regions/us-west1/subnetworks/default"
}

variable "gcp_service_account_email" {
  type        = string
  description = "email of your service account"
}

variable "gcp_service_account_scopes" {
  type        = list(string)
  description = "the scope of your service account, basically permission"
  default     = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
}

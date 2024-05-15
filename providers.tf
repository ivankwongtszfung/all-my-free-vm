terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 4.108.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.oci_tenancy_ocid
  user_ocid        = var.oci_user_ocid
  fingerprint      = var.oci_fingerprint
  private_key_path = var.oci_private_key_path
  region           = var.oci_region
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
  zone    = var.gcp_zone
}

provider "oci" {
    region = var.region
    auth = var.auth
    config_file_profile = var.config_file_profile
}

resource "oci_core_vcn" "internal_vcn" {

    cidr_block     = "172.16.0.0/16"
    dns_label = "internalvcn"
    display_name   = "internal_vcn"
    compartment_id = var.compartment_id

}

resource "oci_core_subnet" "development_subnet" {
    cidr_block     = "172.16.0.0/24"
    vcn_id = oci_core_vcn.internal_vcn.id
    dns_label = "developmentsubnet"
    display_name   = "development_subnet"
    compartment_id = "ocid1.compartment.oc1.datnh"
    prohibit_public_ip_on_vnic = true

  
}
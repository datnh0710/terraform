output "vcn_state" {
  description = "The state of the VCN"
  value       = oci_core_vcn.internal_vcn.state
}

output "vcn_cidr" {
    description = "The CIDR block of the VCN"
    value       = oci_core_vcn.internal_vcn.cidr_block
  
}
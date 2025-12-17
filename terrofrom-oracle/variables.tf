variable "compartment_id" {
    description = "The OCID of the compartment where resources will be created"
    type        = string
    default = "ocid1.compartment.oc1.datnh"
  
}

variable "region" {
    description = "The Oracle Cloud region where resources will be created"
    type        = string
    default = "us-sanjose-1"
  
}

variable "config_file_profile" {
    description = "The profile in the OCI config file to use for authentication"
    type        = string
    default = "development"
  
}

variable "auth" {
    description = "The authentication method to use"
    type        = string
    default = "SecureToken"
}

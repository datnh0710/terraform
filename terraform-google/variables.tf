variable "project_id" {   
  description = "The ID of the Google Cloud project."
  type        = string
  default = "project_id"
}

variable "project" {
  
}

variable "region" {
  description = "The region to deploy resources in."
  type        = string
  default = "us-central1"
  
}

variable "zone" {
  description = "The zone to deploy resources in."
  type        = string
  default = "us-central1-a"
  
}

variable "network_name" {   
  description = "The name of the VPC network."
  type        = string
  default = "my-vpc-network"
  
}

variable "instance_name" {
    description = "The name of the VM instance."
    type        = string
    default = "my-vm-instance"
  
}

variable "machine_type" {   
    description = "The machine type for the VM instance."
    type        = string
    default = "e2-medium"
  
}

variable "tags" {
    description = "A list of tags to associate with the VM instance."
    type        = list(string)
    default = ["web","dev"]
  
}
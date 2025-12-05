variable "tags" {
  type = map(string)
  default = {
    Environment = "Dev"
    CostCenter  = "IT"
    Team       = "DevOps"
  } 
}

variable "resource_group_name" {
    type    = string
    default = "myTFResourceGroup"
  
}

variable "location" {
    type    = string
    default = "West US"
}
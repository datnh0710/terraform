variable "instance_name" {
  description = "For the Web App"
  type = string
  default = "WebAppServer"
}


variable "instance_type" {
    description = "Type of AWS EC2 instance"
    type = string
    default = "t2.micro"
}
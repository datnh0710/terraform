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

variable "iam_user_admin_name" {
  description = "Name of the IAM user"
  type        = string
  default     = "admin-user"
}

variable "iam_user_admin_policy_name" {
  description = "Name of the IAM user policy"
  type        = string
  default     = "admin-user-policy"
}

variable "aws_s3_bucket" {  
  description = "Name of the S3 bucket"
  type        = string
  default     = "my-app-image-bucket-1234567890"
  
}

variable "aws_s3_bucket_tag" {  
  description = "Tags for the S3 bucket"
  type        = map(string)
  default     = {
    Name        = "AppImageBucket"
    Environment = "Development" 
    description = "Bucket for storing application images"
  }
  
}

variable "aws_dynamodb_table" { 
  description = "Name of the DynamoDB table"
  type        = string
  default     = "AppTable"
  
}
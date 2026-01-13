provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_user" "admin-user" {
  name = var.iam_user_admin_name
  path = "/system/"
  tags = {
    "Description" = "Admin Lead"
    "Role" = "admin"
  }
}

resource "aws_iam_policy" "admin-user-policy" {
  name        = var.iam_user_admin_policy_name
  description = var.iam_user_admin_policy_name.description
  policy      = file("admin-policy.json")
  
}

resource "aws_iam_user_policy_attachment" "admin-user-policy-attachment" {
  user       = aws_iam_user.admin-user.name
  policy_arn = aws_iam_policy.admin-user-policy.arn
}

resource "aws_s3_bucket" "image" {
  bucket = var.aws_s3_bucket

  tags = var.aws_s3_bucket_tag
}

resource "aws_s3_bucket_object" "sample_image" {
  bucket = aws_s3_bucket.image.id
  key    = "sample-image.jpg"
  source = "images/sample-image.jpg"
  acl    = "private"
  
}

data "aws_iam_group" "administrators" {
  group_name = "Administrators"
  
}

resource "aws_s3_bucket_policy" "image_policy" {
  bucket = aws_s3_bucket.image.id

  policy = file("s3-image-policy.json")
  
}

resource "aws_dynamodb_table" "app_table" {
  name         = var.aws_dynamodb_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "AppID"

  attribute {
    name = "AppID"
    type = "S"
  }

  tags = {
    Environment = "Development"
    Name        = "AppDynamoDBTable"
  }
  
}

resource "aws_dynamodb_table_item" "app_table_item" {
  table_name = aws_dynamodb_table.app_table.name
  hash_key   = aws_dynamodb_table.app_table.hash_key

    item = <<EOF
        {
          "AppID": {"S": "app-001"},
          "AppName": {"S": "MyFirstApp"},
          "Version": {"S": "1.0.0"} 
          
        }
  EOF
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
  
}


resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.app_server_sg.id]

  provisioner "local-exec" {
    command = "echo 'Instance ${self.id} with IP ${self.public_ip} created' >> instance_info.txt"
    
  }

  provisioner "local-exec" {
    on_failure = fail
    command    = "echo 'Instance creation failed' >> instance_info.txt"
    
  }

  provisioner "local-exec" {
    when    = destroy
    command = "echo 'Instance ${self.id} is being destroyed' >> instance_info.txt"
    
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y apache2",
      "sudo systemctl start apache2",
      "sudo systemctl enable apache2"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
    
  }

  tags = {
    Name = var.instance_name
  }
  
}

resource "aws_key_pair" "app_server_key" {
  key_name   = "app-server-key"
  public_key = file("~/.ssh/id_rsa.pub")
  
}

resource "aws_security_group" "app_server_sg" {
  name        = "app-server-sg"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "5.19.0"
    
    name = "default-vpc"
    cidr = "10.0.0.0/16"

    azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
    public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnets = ["10.0.101.0/24"]
    enable_nat_gateway = true
    enable_dns_hostnames = true
  
}
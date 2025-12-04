output "instance_host" {
  description = "Private DSN name of the EC2 instance"
  value       = aws_instance.app_server.private_dns
}
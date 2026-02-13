output "instance_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.quotes_server.public_ip
}

output "application_url" {
  description = "URL to access the Flask Application"
  value       = "http://${aws_instance.quotes_server.public_ip}:5000"
}
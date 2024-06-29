
# Output for static website instance
output "static_website_instance_public_ip" {
  value = aws_instance.static_website_instance.public_ip
}




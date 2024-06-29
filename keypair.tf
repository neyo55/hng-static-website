# keypair.tf
# This file is used to create a key pair in AWS and store the private key in a local file.

# Ensure the directory for storing the private key exists 
resource "local_file" "private_key" {
  content  = tls_private_key.my_private_key.private_key_pem
  filename = "${path.module}/file/static-web-key.pem"
}

# Create a key pair in AWS
resource "aws_key_pair" "static_website_keypair" {
  key_name   = var.static_website_keypair_name
  public_key = tls_private_key.my_private_key.public_key_openssh # Use the public key generated from a TLS private key
}

# Generate a TLS private key
resource "tls_private_key" "my_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}



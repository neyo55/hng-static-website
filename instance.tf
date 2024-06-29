# instance.tf

# Fetch the latest Ubuntu AMI using a data source
data "aws_ami" "ubuntu_static_website" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's AWS account ID for Ubuntu AMIs

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# # Create elastic IP for Netflix instance
# resource "aws_eip" "netflix_lb" {
#   instance   = aws_instance.netflix_app_instance.id
#   domain     = "vpc"
#   depends_on = [aws_instance.netflix_app_instance]
# }

# # Associate the elastic IP with the Netflix instance
# resource "aws_eip_association" "netflix_eip_assoc" {
#   instance_id   = aws_instance.netflix_app_instance.id
#   allocation_id = aws_eip.netflix_lb.id
# }

# create static website instance 
resource "aws_instance" "static_website_instance" {
  ami             = data.aws_ami.ubuntu_static_website.id
  instance_type   = var.instance_type_static_website
  subnet_id       = aws_subnet.static_website_subnet.id
  key_name        = aws_key_pair.static_website_keypair.key_name
  security_groups = [aws_security_group.static_website_security_group.id]
  depends_on      = [aws_key_pair.static_website_keypair, aws_subnet.static_website_subnet, aws_security_group.static_website_security_group]

  user_data = filebase64("nginx-setup.sh")

  # provisioner "file" {
  #   source      = "./website/my-pic-base64.txt"
  #   destination = "/tmp/my-pic-base64.txt"
  # }

  tags = {
    Name = "${var.project_name}_instance"
  }

}

















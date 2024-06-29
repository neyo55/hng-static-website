# security-group.tf

# create a security group for the instance 
resource "aws_security_group" "static_website_security_group" {
  name        = "static_website_security_group"
  description = "Allow traffic"
  vpc_id      = aws_vpc.static_website_vpc.id

  ingress {
    description = "STATIC_WEBSITE_SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "STATIC_WEBSITE_HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    description = "All traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}_security_group"
  }

}







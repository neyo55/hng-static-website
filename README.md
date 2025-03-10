
# Static Website Deployment on AWS EC2 using Terraform

## Project Description

This project involves deploying a static website on an AWS EC2 instance using Terraform. The website includes a simple HTML page styled with CSS and enhanced with JavaScript functionality. The deployment script also sets up NGINX to serve the website.

## Prerequisites

Before deploying this project, ensure you have the following:

1. **Terraform** installed on your local machine. [Installation Guide](https://learn.hashicorp.com/tutorials/terraform/install-cli)
2. **AWS CLI** installed and configured with appropriate permissions to create resources. [Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
3. An AWS account with permissions to create VPC, Subnets, Security Groups, EC2 Instances, and Key Pairs.

## Project Structure

- `provider.tf`: Configures the AWS provider.
- `network.tf`: Creates the VPC, Subnet, Internet Gateway, and Route Table.
- `security-group.tf`: Creates the Security Group for the EC2 instance.
- `keypair.tf`: Generates an SSH key pair and stores the private key locally.
- `instance.tf`: Creates the EC2 instance and deploys the static website.
- `variables.tf`: Defines the variables used in the Terraform configuration.
- `terraform.tfvars`: Contains the values for the variables defined in `variables.tf`.
- `output.tf`: This output the public ip of the instance after applying the configuration.
- `nginx-setup.sh`: Bash script to install NGINX and set up the static website.
- `website/index.html`: The HTML file for the static website.
- `website/styles.css`: The CSS file for the static website.
- `website/script.js`: The JavaScript file for the static website.

## Deployment Instructions

1. **Clone the repository**:
    ```bash
    git clone <repository-url>
    cd <repository-directory>
    ```

2. **Review and modify variable values** in `terraform.tfvars` as necessary.

3. **Initialize Terraform**:
    ```bash
    terraform init
    ```

4. **Validate the setup**:
    ```bash
    terraform validate
    ```

5. **Plan the setup to detect errors**:
    ```bash
    terraform plan
    ```

6. **Apply the Terraform configuration**:
    ```bash
    terraform apply --auto-approve
    ```

**Access the deployed website** using the public IP address of the created EC2 instance with the port 80 that was allowed, which will be displayed as an output after applying the Terraform configuration. For example, http://3.255.161.200:80

## Configuration Details

### Provider Configuration (`provider.tf`)

This file sets up the AWS provider with the specified region and profile.

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = "default"
}
```

### Network Configuration (`network.tf`)

This file creates a VPC, Subnet, Internet Gateway, and Route Table.

```hcl
resource "aws_vpc" "static_website_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.project_name}_vpc"
  }
}

resource "aws_subnet" "static_website_subnet" {
  vpc_id                  = aws_vpc.static_website_vpc.id
  cidr_block              = var.subnet_cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}_subnet"
  }
}

resource "aws_internet_gateway" "static_website_igw" {
  vpc_id = aws_vpc.static_website_vpc.id
  tags = {
    Name = "${var.project_name}_internet_gateway"
  }
}

resource "aws_route_table" "static_website_route_table" {
  vpc_id = aws_vpc.static_website_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.static_website_igw.id
  }
  tags = {
    Name = "${var.project_name}_route_table"
  }
}

resource "aws_route_table_association" "static_website_route_table_association" {
  subnet_id      = aws_subnet.static_website_subnet.id
  route_table_id = aws_route_table.static_website_route_table.id
}
```

### Security Group Configuration (`security-group.tf`)

This file creates a security group that allows SSH and HTTP traffic.

```hcl
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
```

### Key Pair Configuration (`keypair.tf`)

This file generates an SSH key pair and stores the private key locally in the folder named 'file'. Make sure the folder is created in the root directory of your setup files before applying the configuration.

```hcl
resource "local_file" "private_key" {
  content  = tls_private_key.my_private_key.private_key_pem
  filename = "${path.module}/file/static-web-key.pem"
}

resource "aws_key_pair" "static_website_keypair" {
  key_name   = var.static_website_keypair_name
  public_key = tls_private_key.my_private_key.public_key_openssh
}

resource "tls_private_key" "my_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
```

### EC2 Instance Configuration (`instance.tf`)

This file creates the EC2 instance and deploys the static website using a user data script.

```hcl
data "aws_ami" "ubuntu_static_website" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "static_website_instance" {
  ami             = data.aws_ami.ubuntu_static_website.id
  instance_type   = var.instance_type_static_website
  subnet_id       = aws_subnet.static_website_subnet.id
  key_name        = aws_key_pair.static_website_keypair.key_name
  security_groups = [aws_security_group.static_website_security_group.id]
  depends_on      = [aws_key_pair.static_website_keypair, aws_subnet.static_website_subnet, aws_security_group.static_website_security_group]

  user_data = filebase64("nginx-setup.sh")

  tags = {
    Name = "${var.project_name}_instance"
  }
}

output "static_website_instance_public_ip" {
  value = aws_instance.static_website_instance.public_ip
}
```

### Variables and Terraform Variables File

The variables are defined in `variables.tf` and their values are provided in `terraform.tfvars`.

```hcl
# variables.tf

variable "region" {}
variable "project_name" {}
variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "availability_zone" {}
variable "static_website_keypair_name" {}
variable "instance_type_static_website" {}

# terraform.tfvars

region = "eu-west-1"
project_name = "static_website"
vpc_cidr_block = "10.0.0.0/16"
subnet_cidr_block = "10.0.1.0/24"
availability_zone = "eu-west-1a"
static_website_keypair_name = "static-web-key"
instance_type_static_website = "t2.micro"
```

## Usage

1. **Initialize Terraform**:
    ```bash
    terraform init
    ```

2. **Plan the setup to detect errors**:
    ```bash
    terraform plan
    ```

3. **Apply the Terraform configuration**:
    ```bash
    terraform apply --auto-approve
    ```

4. **Access the deployed website** using the public IP address displayed in the output.

## License

This project is licensed under the MIT License.
```

You can modify this README template as needed to fit your project specifics. If you need any more details or adjustments, let me know! kbneyo55@gmail.com
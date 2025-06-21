provider "aws" {
  region = var.aws_region
}

# Security Group to allow SSH from your IP
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH from your IP"

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["143.44.165.146/32"] # ✅ Your current public IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance to run K3s
resource "aws_instance" "k3s_node" {
  ami                         = "ami-02c7683e4ca3ebf58" # ✅ Ubuntu 24.04 LTS x86_64 for ap-southeast-1
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  tags = {
    Name = "k3s-master"
  }

  # Automatically install K3s
  provisioner "remote-exec" {
    inline = [
      "curl -sfL https://get.k3s.io | sh -"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("/Users/john.abucay/infrabukiks/aws-cred/infrabukiks.pem")
      host        = self.public_ip
    }
  }
}

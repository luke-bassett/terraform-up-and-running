provider "aws" {
  profile = "terraform"
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami                    = "ami-075686beab831bb7f" # ubuntu
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "hello world" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  user_data_replace_on_change = true
  tags = {
    Name = "tf-example"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  ingress {
    from_port = var.server_port
    to_port   = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# input variable - keep it DRY
variable "server_port" {
  description = "the port the server will use for http requests"
  type        = number
  default     = 8080
}

# output variable - will show after apply
output "public_ip" {
  description = "the public IP of the web server"
  value       = aws_instance.example.public_ip
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Official Canonical account ID
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  # 2. Automatically install and start Tomcat when the server boots
  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y tomcat10
              systemctl start tomcat10
              systemctl enable tomcat10
              EOF

  tags = {
    Name = "HelloWorld"
  }
}

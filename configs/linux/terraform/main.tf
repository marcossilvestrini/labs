provider "aws" {
  region = "us-east-1"
  #access_key = "<YOUR ACCESS KEY HERE>"
  #secret_key = "<YOUR SECRET KEY HERE>"
}
resource "aws_instance" "tfvm" {
  ami = "ami-0885b1f6bd170450c"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.websg.id ]
  user_data = <<-EOF
                #!/bin/bash
                echo "This app has build with terraform by Marcos Silvestrini - 2023" > index.html
                nohup busybox httpd -f -p 8080 &
                EOF
    tags = {
      Name = "silvestrini-demo"
    }
}
resource "aws_security_group" "websg" {
  name = "web-sg01"
  ingress {
    protocol = "tcp"
    from_port = 8080
    to_port = 8080
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}
output "instance_ips" {
  value = aws_instance.tfvm.public_ip
}


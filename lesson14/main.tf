provider "aws" {
  region = "ap-east-1"  # Гонконг, как ты выбрал ранее
}

resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "lesson14-main-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "lesson14-public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-east-1a"

  tags = {
    Name = "lesson14-private-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "lesson14-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "lesson14-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_key_pair" "lesson_key" {
  key_name   = "lesson14-key"
  public_key = file("~/.ssh/foransible_id.pub")  
}

resource "aws_instance" "public_vm" {
  ami                         = "ami-05ae90918b7392f01"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  key_name                    = aws_key_pair.lesson_key.key_name
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  associate_public_ip_address = true

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/foransible_id")
      host        = self.public_ip
    }
  }

  tags = {
    Name = "lesson14-public-vm"
  }
}

resource "aws_instance" "private_vm" {
  ami                         = "ami-05ae90918b7392f01"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.private_subnet.id
  key_name                    = aws_key_pair.lesson_key.key_name
  vpc_security_group_ids      = [aws_security_group.private_sg.id]
  associate_public_ip_address = false

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx"
    ]

    connection {
      type                = "ssh"
      user                = "ubuntu"
      private_key         = file("~/.ssh/foransible_id")
      host                = self.private_ip
      bastion_host        = aws_instance.public_vm.public_ip
      bastion_user        = "ubuntu"
      bastion_private_key = file("~/.ssh/foransible_id")
    }
  }

  tags = {
    Name = "lesson14-private-vm"
  }
}

resource "aws_security_group" "public_sg" {
  name        = "lesson14-public-sg"
  description = "Allow SSH and HTTP/S from anywhere"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lesson14-public-sg"
  }
}

resource "aws_security_group" "private_sg" {
  name        = "lesson14-private-sg"
  description = "Allow SSH and 8080 from anywhere"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "App Port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lesson14-private-sg"
  }
}

         
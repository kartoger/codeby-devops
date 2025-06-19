resource "aws_instance" "manual_vm" {
  ami           = "ami-0a5e465d791bed879"
  instance_type = "t3.micro"             
  subnet_id     = "subnet-0def58a906fc89f90" 
  associate_public_ip_address = true
  tags = {
    Name = "manual-vm"
  }
}
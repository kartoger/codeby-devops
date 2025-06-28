variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs"
}

variable "availability_zone" {
  type        = string
  description = "Availability_zone"
}

variable "ami_id" {
  type        = string
  description = "AMI"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  type        = string
  description = "SSH"
}

variable "preferred_tier" {
  type        = string
  default     = null
  description = "public/private"
}

data "aws_subnet" "each" {
  for_each = toset(var.subnet_ids)
  id       = each.value
}

locals {
  matching_subnet_id = one([
    for s in data.aws_subnet.each :
    s.id if (
      s.availability_zone == var.availability_zone &&
      (
        var.preferred_tier == null || try(s.tags["Tier"], "") == var.preferred_tier
      )
    )
  ])
}


resource "aws_instance" "vm" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = local.matching_subnet_id
  associate_public_ip_address = true

}
output "subnet_used" {
     value = aws_instance.vm.subnet_id 
     }
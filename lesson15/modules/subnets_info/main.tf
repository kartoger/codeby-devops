data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}
data "aws_subnet" "each" {
  for_each = toset(data.aws_subnets.all.ids)
  id       = each.value
}
variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
}
output "subnet_ids" {
  description = "List subnet IDs"
  value = data.aws_subnets.all.ids
}
output "details" {
  description = "Detailed subnet info: AZ, CIDR, public IP flag, tags"
  value = {
    for id, subnet in data.aws_subnet.each :
    id => {
      az        = subnet.availability_zone
      cidr      = subnet.cidr_block
      public_ip = subnet.map_public_ip_on_launch
      tags      = subnet.tags
    }
  }
}
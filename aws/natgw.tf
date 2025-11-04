resource "aws_eip" "natgw_eip" {
  tags = {
    Name = "${var.project}-natgw-eip"
  }
}

resource "aws_nat_gateway" "natgw" {
    allocation_id = aws_eip.natgw_eip.id
    subnet_id     = aws_subnet.subnets[var.nat_gateway_subnet_name].id

  tags = {
    Name = "${var.project}-natgw"
  }
}
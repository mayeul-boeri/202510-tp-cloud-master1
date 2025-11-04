
# Table de routage publique
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.tp-vpc.id

  tags = {
    Name = "${var.project}-public-rt"
  }
}

# Route 0.0.0.0/0 vers l'Internet Gateway
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Association de la table publique aux subnets publics
resource "aws_route_table_association" "public" {
  for_each       = { for subnet in var.subnets : subnet.name => subnet if subnet.type == "public" }
  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = aws_route_table.public_rt.id
}




# Table de routage privée
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.tp-vpc.id
  tags = {
    Name = "${var.project}-private-rt"
  }
}

# Route 0.0.0.0/0 vers la NAT Gateway
resource "aws_route" "private_nat_access" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgw.id
}

# Association de la table privée aux subnets privés
resource "aws_route_table_association" "private" {
  for_each       = { for subnet in var.subnets : subnet.name => subnet if subnet.type == "private" }
  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = aws_route_table.private.id
}
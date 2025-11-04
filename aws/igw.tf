resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.tp-vpc.id

  tags = {
    Name = "${var.project}-igw"
  }
}
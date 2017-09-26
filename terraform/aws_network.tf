data "aws_availability_zones" "available" {}

resource "aws_vpc" "myvpc" {
  cidr_block = "10.99.0.0/16"
}

resource "aws_subnet" "mysubnet" {
  count             = "${var.az_qty}"
  cidr_block        = "${cidrsubnet(aws_vpc.myvpc.cidr_block, 8, count.index)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  vpc_id            = "${aws_vpc.myvpc.id}"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.myvpc.id}"
}

resource "aws_route_table" "route" {
  vpc_id = "${aws_vpc.myvpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
}

resource "aws_route_table_association" "table" {
  count          = "${var.az_qty}"
  subnet_id      = "${element(aws_subnet.mysubnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.route.id}"
}

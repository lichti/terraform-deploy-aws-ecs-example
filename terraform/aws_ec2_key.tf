resource "aws_key_pair" "admin_key" {
  key_name   = "admin_key"
  public_key = "${var.admin_public_key}"
}

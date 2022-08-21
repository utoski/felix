resource "aws_key_pair" "mykeypair21" {
  key_name   = "mykeypair21"
  public_key = file(var.PUBLIC_KEY)
  lifecycle {
    ignore_changes = [public_key]
  }
}
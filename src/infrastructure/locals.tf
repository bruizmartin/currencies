locals {
  public_subnet_ids = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

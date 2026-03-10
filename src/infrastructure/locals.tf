locals {
  public_subnet_ids  = [aws_subnet.public_a.id, aws_subnet.public_b.id]
  private_subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id]
}

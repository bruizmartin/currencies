locals {
  az_subnet_config = {
    a = {
      az_index     = 0
      public_cidr  = var.public_subnet_cidr_a
      private_cidr = var.private_subnet_cidr_a
    }
    b = {
      az_index     = 1
      public_cidr  = var.public_subnet_cidr_b
      private_cidr = var.private_subnet_cidr_b
    }
  }

  public_subnet_ids  = [for az in ["a", "b"] : aws_subnet.public[az].id]
  private_subnet_ids = [for az in ["a", "b"] : aws_subnet.private[az].id]
}

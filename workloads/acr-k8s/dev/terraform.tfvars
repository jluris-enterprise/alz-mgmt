location = "uksouth"

address_space = "172.0.0.0/18"

subnets = {
  pods = {
    size                       = 23
    has_nat_gateway            = false
    has_network_security_group = false
  }
  node = {
    size                       = 24
    has_nat_gateway            = false
    has_network_security_group = false
  }
  private = {
    size                       = 22
    has_nat_gateway            = false
    has_network_security_group = true
  }
}

tags = {
  environment = "dev"
  workload    = "acr-k8s"
}
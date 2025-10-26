location = "uaenorth"

address_space = "172.0.0.0/18"

user_assigned_managed_identities = {
  uami = {
    name = "uami-$${workload}-$${environment}-$${location}-$${sequence}"
  }
  kubelet = {
    name = "uami-kubelet-$${workload}-$${environment}-$${location}-$${sequence}"
  }
  # for node uami
  kubernetes = {
    name = "uami-kubernetes-$${workload}-$${environment}-$${location}-$${sequence}"
  }
}

subnets = {
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

fic_subjects = {
  pull_request = {
    audience = "api://AzureADTokenExchange"
    issuer   = "https://token.actions.githubusercontent.com"
    subject  = "repo:jluris-enterprise/flask:pull_request"
  }
  github_actions = {
    audience = "api://AzureADTokenExchange"
    issuer   = "https://token.actions.githubusercontent.com"
    subject  = "repo:jluris-enterprise/flask:ref:refs/heads/main"
  }
}

tags = {
  environment = "dev"
  workload    = "acr-k8s"
}

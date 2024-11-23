variable k8splane {
  type = map(object({
    vmid = number
    name = string
    memory = number
    cores = number
    sockets = number
    ipconfig = string
    tags = string
    disk_size = number
  }))
  default = {
    plane = {
      vmid = 200
      name = "k8s-plane-01"
      memory = 4096
      cores = 2
      sockets = 2
      ipconfig = "ip=172.16.0.20/24,gw=172.16.0.1"
      tags = "staging,k8s,plane"
      disk_size = 32
    }
  }
}
variable k8sworker {
  type = map(object({
    vmid = number
    name = string
    memory = number
    cores = number
    sockets = number
    ipconfig = string
    tags = string
    disk_size = string
  }))
  default = {
    worker1 = {
      vmid = 201
      name = "k8s-worker-01"
      memory = 4096
      cores = 1
      sockets = 2
      ipconfig = "ip=172.16.0.21/24,gw=172.16.0.1"
      tags = "staging,k8s,worker"
      disk_size = 100
    }
    worker2 = {
      vmid = 202
      name = "k8s-worker-02"
      memory = 4096
      cores = 1
      sockets = 2
      ipconfig = "ip=172.16.0.22/24,gw=172.16.0.1"
      tags = "staging,k8s,worker"
      disk_size = 100
    }
    worker3 = {
      vmid = 203
      name = "k8s-worker-03"
      memory = 4096
      cores = 1
      sockets = 2
      ipconfig = "ip=172.16.0.23/24,gw=172.16.0.1"
      tags = "staging,k8s,worker"
      disk_size = 100
    }
  }
}

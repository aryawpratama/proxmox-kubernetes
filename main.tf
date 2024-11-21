resource "proxmox_vm_qemu" "k8s-plane" {
  for_each = var.k8splane
  
  target_node = "jayaserver01"
  vmid        = each.value.vmid
  name        = each.value.name
  tags        = each.value.tags
  clone       = "ubuntu-2204-template"
  onboot      = true
  agent       = 1
  vm_state    = "started"

  scsihw      = "virtio-scsi-pci"
  disks {
    ide {
      ide0 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          storage = "local-lvm"
          size    = each.value.disk_size
        }
      }
    }
  }

  cpu        = "host"
  cores      = each.value.cores
  sockets    = each.value.sockets
  memory     = each.value.memory

  os_type    = "cloud-init"
  ipconfig0  = each.value.ipconfig
  cicustom   = "user=backup-pool:snippets/cloudinit.yaml"

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
  serial {
    id   = 0
    type = "socket"
  }
  lifecycle {
    ignore_changes = [
      name,
      ciuser,
      id,
      network,
      ipconfig0
    ]
  }
}
resource "proxmox_vm_qemu" "k8s-worker" {
  for_each = var.k8sworker

  target_node = "jayaserver01"
  vmid        = each.value.vmid
  name        = each.value.name
  tags        = each.value.tags
  clone       = "ubuntu-2204-template"
  onboot      = true
  agent       = 1
  vm_state    = "started"

  scsihw      = "virtio-scsi-pci"
  disks {
    ide {
      ide0 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          storage = "local-lvm"
          size    = each.value.disk_size
        }
      }
    }
  }

  cpu        = "host"
  cores      = each.value.cores
  sockets    = each.value.sockets
  memory     = each.value.memory

  os_type    = "cloud-init"
  ipconfig0  = each.value.ipconfig
  cicustom   = "user=backup-pool:snippets/cloudinit.yaml"

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
  serial {
    id   = 0
    type = "socket"
  }
  lifecycle {
    ignore_changes = [
      name,
      ciuser,
      id,
      network,
      ipconfig0,
      default_ipv4_address,
      ssh_host,
      tags
    ]
  }
}

resource "time_sleep" "wait_cloud_init" {
  depends_on = [ proxmox_vm_qemu.k8s-worker, proxmox_vm_qemu.k8s-plane ]
  create_duration = "5m"
}

resource "null_resource" "run_ansible_kubernetes" {
  depends_on = [ time_sleep.wait_cloud_init ]
  provisioner "local-exec" {
    
    working_dir = "./ansible"
    command = <<EOF
    ansible-playbook --extra-vars "ansible_ssh_password=${var.srv_pass}" site.yaml
    EOF
  }
}
resource "hcloud_server" "primary" {
  name = "${var.nodename}"
  image = "ubuntu-20.04"
  location = var.region
  server_type = "${var.instance_type}"
  ssh_keys = ["${var.admin_key_name}"]
  user_data = templatefile("${path.module}/files/cloud-config.yml", {})
}

resource "null_resource" "install" {
  triggers = {
    primary_ip = hcloud_server.primary.ipv4_address
    private_ip = hcloud_server_network.private.ip
    key_file = var.connection_key_file
  }

  provisioner "file" {
    content = templatefile("${path.module}/files/dashboard.yaml", {})
    destination = "/tmp/dashboard.yaml"
  }

  provisioner "file" {
    content = templatefile("${path.module}/files/setup.sh", {primary_ip = self.triggers.primary_ip, private_ip = self.triggers.private_ip})
    destination = "/tmp/setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/setup.sh",
        "/tmp/setup.sh"
    ]
  }

  connection {
          type = "ssh"
          user = "root"
          host = hcloud_server.primary.ipv4_address
          private_key = file(var.connection_key_file)
      }
}

resource "null_resource" "addnode" {

  //count = var.node_active ? 1 : 0

  triggers = {
    primary_ip = hcloud_server.primary.ipv4_address
    key_file = var.connection_key_file
  }

  for_each = toset(var.node_connect_hashes)

  provisioner "remote-exec" {
      inline = [
          "while [ ! -f /snap/bin/microk8s ]; do sleep 1; done",
          "microk8s.status --wait-ready",
          "microk8s add-node --token ${each.value} --token-ttl 86400"
      ]
  }

  connection {
          type = "ssh"
          user = "root"
          host = hcloud_server.primary.ipv4_address
          private_key = file(var.connection_key_file)
      }

  depends_on = [
    null_resource.install
  ]
}

resource "hcloud_server_network" "private" {
    server_id = hcloud_server.primary.id
    network_id = var.private_net_id
}

# Provider
terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.31.1"
    }
  }
}

provider "hcloud" {
    token = "${var.token}"
}
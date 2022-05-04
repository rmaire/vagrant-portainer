resource "hcloud_server" "node" {

  count = var.node_active ? 1 : 0

  name = "${var.nodename}"
  image = "ubuntu-20.04"
  location = var.region
  server_type = "${var.instance_type}"
  ssh_keys = ["${var.admin_key_name}"]
  user_data = templatefile("${path.module}/files/cloud-config.yml", {})

  /*provisioner "file" {
      content = templatefile("${path.module}/files/setup.sh", {primary_ip = var.primary_private_ip, hash_node = var.node_connect_hash})
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
          host = self.ipv4_address
          private_key = file(var.connection_key_file)
      }*/
}

resource "null_resource" "setup" {

  count = var.node_active ? 1 : 0

  triggers = {
    primary_ip = var.primary_private_ip
    key_file = var.connection_key_file
    hash_node = var.node_connect_hash
    ipv4_address = hcloud_server.node[0].ipv4_address
  }

  provisioner "file" {
      content = templatefile("${path.module}/files/setup.sh", {primary_ip =self.triggers.primary_ip, hash_node = self.triggers.hash_node})
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
          host = self.triggers.ipv4_address
          private_key = file(self.triggers.key_file)
      }
}

/*resource "null_resource" "addnode" {

  count = var.node_active ? 1 : 0

  triggers = {
    primary_ip = var.primary_private_ip
    key_file = var.connection_key_file
    hash_node = var.node_connect_hash
  }

  provisioner "remote-exec" {
      inline = [
          "while [ ! -f /snap/bin/microk8s ]; do sleep 1; done",
          "sudo microk8s add-node --token ${self.triggers.hash_node}"
      ]
  }

  connection {
          type = "ssh"
          user = "root"
          host = self.triggers.primary_ip
          private_key = file(self.triggers.key_file)
      }
}*/

resource "hcloud_server_network" "private" {
    count = var.node_active ? 1 : 0
    server_id = hcloud_server.node[0].id
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
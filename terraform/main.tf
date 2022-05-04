variable "cluster_domain" {}
variable "token" {}
variable "region" {}
variable "connection_key_file" {}
variable "admin_key_name" {}
variable "node_connect_hashes" {
	type    = list(string)
	default = ["c69965b1a51667759bbf714676552d95"]
}

# Main Node
module "k8s-main-v1" {
  source = "./primary"

  nodename            = "main-v1"

  cluster_domain      = "${var.cluster_domain}"
  token               = "${var.token}"
  region              = "${var.region}"
  instance_type       = "cx21"
  connection_key_file = "${var.connection_key_file}"
  admin_key_name      = "${var.admin_key_name}"
  private_net_id      = "${hcloud_network_subnet.internal.network_id}"
  node_connect_hashes = var.node_connect_hashes
}

output "k8s-main-v1-public-ip" {
  value = "${module.k8s-main-v1.public_ip}"
}

output "k8s-main-v1-private-ip" {
  value = "${module.k8s-main-v1.private_ip}"
}

output "k8s-main-v1-ssh" {
  value = format("ssh -i ~/.ssh/id_rma administrator@%s", module.k8s-main-v1.public_ip)
}

# Node 1
module "k8s-node1-v1" {
  source = "./node"

  nodename            = "node1-v1"
  node_active         = true

  node_connect_hash   = "${var.node_connect_hashes[0]}"
  cluster_domain      = "${var.cluster_domain}"
  token               = "${var.token}"
  region              = "${var.region}"
  instance_type       = "cx21"
  primary_private_ip  = module.k8s-main-v1.private_ip
  primary_public_ip   = module.k8s-main-v1.public_ip
  connection_key_file = "${var.connection_key_file}"
  admin_key_name      = "${var.admin_key_name}"
  private_net_id      = "${hcloud_network_subnet.internal.network_id}"
}

output "k8s-node1-v1-public-ip" {
  value = "${module.k8s-node1-v1.public_ip}"
}

output "k8s-node1-v1-private-ip" {
  value = "${module.k8s-node1-v1.private_ip}"
}

output "k8s-node1-v1-ssh" {
  value = format("ssh -i ~/.ssh/id_rma administrator@%s", module.k8s-node1-v1.public_ip)
}

# Node 2
module "k8s-node2-v1" {
  source = "./node"

  nodename            = "node2-v1"
  node_active         = true

  node_connect_hash   = "${var.node_connect_hashes[0]}"
  cluster_domain      = "${var.cluster_domain}"
  token               = "${var.token}"
  region              = "${var.region}"
  instance_type       = "cx21"
  primary_private_ip  = module.k8s-main-v1.private_ip
  primary_public_ip   = module.k8s-main-v1.public_ip
  connection_key_file = "${var.connection_key_file}"
  admin_key_name      = "${var.admin_key_name}"
  private_net_id      = "${hcloud_network_subnet.internal.network_id}"
}

output "k8s-node2-v1-public-ip" {
  value = "${module.k8s-node2-v1.public_ip}"
}

output "k8s-node2-v1-private-ip" {
  value = "${module.k8s-node2-v1.private_ip}"
}

output "k8s-node2-v1-ssh" {
  value = format("ssh -i ~/.ssh/id_rma administrator@%s", module.k8s-node2-v1.public_ip)
}

# Network
resource "hcloud_network" "internal" {
  name     = "internalnet-prod"
  ip_range = "10.0.2.0/24"
}

resource "hcloud_network_subnet" "internal" {
  network_id   = "${hcloud_network.internal.id}"
  type         = "server"
  network_zone = "eu-central"
  ip_range     = "10.0.2.0/24"
}

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
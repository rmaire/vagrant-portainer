output "public_ip" {
  value = length(hcloud_server.node) > 0 ? hcloud_server.node[0].ipv4_address : ""
}

output "private_ip" {
  value = length(hcloud_server_network.private) > 0 ? hcloud_server_network.private[0].ip : ""
}
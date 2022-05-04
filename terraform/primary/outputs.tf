output "public_ip" {
  value = hcloud_server.primary.ipv4_address
}

output "private_ip" {
  value = hcloud_server_network.private.ip
}

output "hostname" {
  value = hcloud_server.primary.name
}
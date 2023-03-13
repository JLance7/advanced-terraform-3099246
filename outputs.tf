output "subnet-gateway" {
  value = google_compute_subnetwork.subnet-1.gateway_address
}

output "nginx-public-ip" {
  value = google_compute_instance.nginx_instance.network_interface[0].access_config[0].nat_ip
}

# output "web1-private-ip" {
#   value = google_compute_instance.web1.network_interface[0].network_ip
# }

# output "web2-private-ip" {
#   value = google_compute_instance.web2.network_interface[0].network_ip
# }

# output "web3-private-ip" {
#   value = google_compute_instance.web3.network_interface[0].network_ip
# }

# output "db-private-ip" {
#   value = google_comput_instance.mysqldb.network_interface[0].network_ip
# }

# output "webserver-ips" {
#   value = google_compute_instance.web-instances[*].network_interface[0].network_ip
# }
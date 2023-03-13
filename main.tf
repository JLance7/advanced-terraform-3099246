### PROVIDER
provider "google" {
  project = var.project-id
  region  = var.region
  zone    = var.zone
}

### COMPUTE
## NGINX PROXY
resource "google_compute_instance" "nginx_instance" {
  name         = "nginx-proxy"
  machine_type = var.environment_machine_type[var.target_environment]
  labels = {
    environment = var.environment_map[var.target_environment]
  }
  tags = var.compute-source-tags
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = data.google_compute_network.default.self_link
    subnetwork = google_compute_subnetwork.subnet-1.self_link
    access_config {
  
    }
  }
}

## WEBSERVERS-MAP
resource "google_compute_instance" "web-map-instances" {
  for_each = var.environment_instance_settings
  name = "${lower(each.key)}-web"
  machine_type = each.value.machine_type
  labels = each.value.labels

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = data.google_compute_network.default.self_link
    subnetwork = google_compute_subnetwork.subnet-1.self_link
  }
}

## WEB-instances
resource "google_compute_instance" "web-instances" {
  count = 3
  name         = "web${count.index}"
  machine_type = var.environment_machine_type[var.target_environment]
  labels = {
    environment = var.environment_map[var.target_environment]
  }
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = data.google_compute_network.default.self_link
    subnetwork = google_compute_subnetwork.subnet-1.self_link
  }
}

## DB
resource "google_compute_instance" "mysqldb" {
  name         = "mysqldb"
  machine_type = var.environment_machine_type[var.target_environment]
  labels = {
    environment = var.environment_map[var.target_environment]
  }
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = data.google_compute_network.default.self_link
    subnetwork = google_compute_subnetwork.subnet-1.self_link
  }  
}

# ## WEB1
# resource "google_compute_instance" "web1" {
#   name         = "web1"
#   machine_type = var.environment_machine_type[var.target_environment]
#   labels = {
#     environment = var.environment_map[var.target_environment]
#   }
  
#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-11"
#     }
#   }

#   network_interface {
#     # A default network is created for all GCP projects
#     network = data.google_compute_network.default.self_link
#     subnetwork = google_compute_subnetwork.subnet-1.self_link
#   }
# }
# ## WEB2
# resource "google_compute_instance" "web2" {
#   name         = "web2"
#   machine_type = var.environment_machine_type[var.target_environment]
#   labels = {
#     environment = var.environment_map[var.target_environment]
#   }
  
#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-11"
#     }
#   }

#   network_interface {
#     network = data.google_compute_network.default.self_link
#     subnetwork = google_compute_subnetwork.subnet-1.self_link
#   }
# }
# ## WEB3
# resource "google_compute_instance" "web3" {
#   name         = "web3"
#   machine_type = var.environment_machine_type[var.target_environment]
#   labels = {
#     environment = var.environment_map[var.target_environment]
#   }
  
#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-11"
#     }
#   }

#   network_interface {
#     network = data.google_compute_network.default.self_link
#     subnetwork = google_compute_subnetwork.subnet-1.self_link
#   }  
# }

# resource "random_id" "db_name_suffix" {
#   byte_length = 4
# }

# ## CLOUD SQL
# resource "google_sql_database_instance" "cloudsql" {
#   name             = "web-app-db-${random_id.db_name_suffix.hex}"
#   database_version = "MYSQL_8_0"
#   region           = "us-central1"

#   settings {
#     tier = "db-f1-micro"
#   }
#   deletion_protection = false
# }

# ## CLOUD SQL USER
# resource "google_sql_user" "users" {
#   name     = "db-user"
#   instance = google_sql_database_instance.cloudsql.name
#   password = "notsecurepassword"
# }
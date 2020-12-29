terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 1.22.2"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "devops_key" {
  name = "digital_ocean_terraform"
}

resource "digitalocean_droplet" "wordpress" {
  image              = "centos-8-x64"
  name               = "wordpress-devops"
  region             = var.region
  size               = "s-1vcpu-1gb"
  private_networking = true
  ssh_keys = [
    data.digitalocean_ssh_key.devops_key.id
  ]
}

resource "digitalocean_firewall" "standard_webserver" {
  name = "web-server-ssh-restricted-icmp-blocked"
  droplet_ids = [digitalocean_droplet.wordpress.id]

  inbound_rule { 
    protocol = "tcp"
    port_range = "22"
    source_addresses = ["66.190.113.154/32"]
  }

  inbound_rule { 
    protocol = "tcp"
    port_range = "80"
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule { 
    protocol = "tcp"
    port_range = "443"
    source_addresses = ["0.0.0.0/0"]
  }

  outbound_rule {
    protocol = "udp"
    port_range = "all"
    destination_addresses = ["0.0.0.0/0"]
  }

  outbound_rule {
    protocol = "tcp"
    port_range = "all"
    destination_addresses = ["0.0.0.0/0"]
  }

  outbound_rule {
    protocol = "icmp"
    destination_addresses = ["0.0.0.0/0"]
  }
}

resource "digitalocean_database_cluster" "mysql-db-cluster" {
  name       = "mysql-cluster"
  engine     = "mysql"
  version    = "8"
  size       = "db-s-1vcpu-1gb"
  region     = var.region
  node_count = 1
}

resource "digitalocean_database_db" "wordpress" {
  cluster_id = digitalocean_database_cluster.mysql-db-cluster.id
  name       = "wordpress"
}

resource "digitalocean_database_firewall" "mysql-db-firewall" {
  cluster_id = digitalocean_database_cluster.mysql-db-cluster.id
  
  rule {
    type = "droplet"
    value = digitalocean_droplet.wordpress.id
  }
}

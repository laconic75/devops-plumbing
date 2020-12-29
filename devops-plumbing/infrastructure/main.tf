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

module "webserver" {
  source = "git@github.com:laconic75/terraform-digitalocean-web-application.git"

  image_name           = "centos-8-x64"
  region               = var.region
  droplet_name         = "wordpress-devops"
  droplet_size         = "s-1vcpu-1gb"
  private_networking   = true
  ssh_keys             = [data.digitalocean_ssh_key.devops_key.id]
  ssh_source_addresses = ["66.190.113.154/32"]
}

module "database-cluster" {
  source = "git@github.com:laconic75/terraform-digitalocean-db-cluster.git"

  cluster_name       = "mysql-cluster"
  database_engine    = "mysql"
  database_version   = "8"
  database_name      = "wordpress"
  region             = var.region
  frontend_webserver = module.webserver.id
}

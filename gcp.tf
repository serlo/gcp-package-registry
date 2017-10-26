variable "project" {}
variable "region" {}
variable "bucket" {}
variable "tfstate_bucket" {}

variable "cloudflare_email" {}
variable "cloudflare_token" {}

provider "google" {
  version = "~> 1.1"

  credentials = "${file("keyfile.json")}"
  project = "${var.project}"
  region = "${var.region}"
}

provider "cloudflare" {
  version = "~> 0.1"

  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}

terraform {
  backend "gcs" {
    path = "terraform.tfstate"
  }
}

resource "google_storage_bucket" "tfstate" {
  name = "${var.tfstate_bucket}"
  storage_class = "REGIONAL"
  location = "${var.region}"
}

resource "google_storage_bucket" "package-registry" {
  name = "${var.bucket}"

  # Since the storage is only used by GCF, we don't need a multi-regional bucket
  storage_class = "REGIONAL"
  location = "${var.region}"
}

resource "google_compute_address" "package-registry-proxy" {
  name = "tf-serlo-assets-package-registry-proxy"
}

resource "google_compute_instance" "package-registry-proxy" {
  name = "tf-serlo-assets-package-registry-proxy"
  machine_type = "f1-micro"
  zone = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "debian-9"
    }
  }

  metadata_startup_script = "${file("proxy-startup.sh")}"

  network_interface {
    network = "default"

    access_config {
      nat_ip = "${google_compute_address.package-registry-proxy.address}"
    }
  }

  tags = ["http-server", "https-server"]
}

resource "cloudflare_record" "package-registry" {
  domain = "serlo.org"
  name = "package-registry"
  value = "${google_compute_instance.package-registry-proxy.network_interface.0.access_config.0.assigned_nat_ip}"
  type = "A"
}

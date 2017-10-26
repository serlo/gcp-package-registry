variable "project" {}
variable "region" {}
variable "bucket" {}

provider "google" {
  version = "~> 1.1"

  credentials = "${file("keyfile.json")}"
  project = "${var.project}"
  region = "${var.region}"
}

resource "google_storage_bucket" "package-registry" {
  name = "${var.bucket}"

  # Since the storage is only used by GCF, we don't need a multi-regional bucket
  storage_class = "REGIONAL"
  location = "${var.region}"
}

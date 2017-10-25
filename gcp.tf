provider "google" {
  version = "~> 1.1"
  credentials = "${file("keyfile.json")}"
  project = "serlo-assets"
  // Use us-central1 region since Google Cloud Functions aren't supported in European regions, yet
  region = "us-central1"
}

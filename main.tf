
provider "google" {
  credentials = "${file(var.credential_file_path)}"
  project = "${var.project}"
  region = "${var.region}"
  version = "~> 3.0.0"
}

provider "google-beta" {
  credentials = "${file(var.credential_file_path)}"
  project = "${var.project}"
  region = "${var.region}"
  version = "~> 3.43"
}


variable "gcp_service_list" {
  description ="The list of apis necessary for the project"
  type = list(string)
  default = [
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "iam.googleapis.com"
  ]
}

resource "google_project_service" "gcp_services" {
  for_each = toset(var.gcp_service_list)
  project = "${var.project}"
  service = each.key
}

resource "google_service_account" "service_account" {
  account_id   = "tester"
  display_name = "Terraform"
}

resource "google_project_iam_binding" "project" {
  project = "terraform-iam"
  role    = "roles/editor"

  members = [
    "serviceAccount:${google_service_account.service_account.email}"
  ]
}


output "test" {
  value = google_service_account.service_account.email
  sensitive=true
}
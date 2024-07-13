terraform {
    required_providers {
        google = {
            source = "hashicorp/google"
            version = "5.37.0"
        }
    }
}

provider "google" {
  project     = "test-1-429208"
  region      = "us-west4"
  zone        = "us-west4-b"
}

resource "google_cloud_run_service" "cloudrun-tf" {
  name     = "cloudrun-tf"
  location = "us-west4"

  template {
    spec {
      containers {
        image = "us-west4-docker.pkg.dev/test-1-429208/test1/my-nginx-image"
        ports {
                    container_port = 80
                }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_policy" "pub1-access" {
  location = google_cloud_run_service.cloudrun-tf.location
  service = google_cloud_run_service.cloudrun-tf.name
  policy_data = data.google_iam_policy.pub-1.policy_data
}

data "google_iam_policy" "pub-1" {
  binding { 
    role = "roles/run.invoker"
    members= ["allUsers"]
}
}

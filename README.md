# Terraform Google Cloud Run Service Example

This Terraform configuration sets up a Google Cloud Run service in Google Cloud Platform (GCP).

## Prerequisites

Before you begin, make sure you have the following:

- Terraform installed locally. You can download it from [terraform.io](https://www.terraform.io/downloads.html).
- Google Cloud Platform account and project. Make sure you have set up authentication and have appropriate permissions.

## Usage

### Setup Terraform

1. Clone this repository or create a new directory for your Terraform configuration.

2. Initialize Terraform by running the following command in your project directory:
   
   ```json
   terraform init
   ```

**This configuration uses the Google Cloud provider to manage resources in GCP:**
```json
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.37.0"
    }
  }
}

provider "google" {
  project = "test-1-429208"
  region  = "us-west4"
  zone    = "us-west4-b"
}
```

**Note- ** **Replace "test-1-429208" with your Google Cloud project ID.**

**Creates a Cloud Run service named cloudrun-tf:**
```json
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

```

Adjust the name, location, and image parameters as per your requirements.

**Grants the "roles/run.invoker" role to all users for the Cloud Run service:**
```json
resource "google_cloud_run_service_iam_policy" "pub1-access" {
  location    = google_cloud_run_service.cloudrun-tf.location
  service     = google_cloud_run_service.cloudrun-tf.name
  policy_data = data.google_iam_policy.pub-1.policy_data
}

data "google_iam_policy" "pub-1" {
  binding {
    role    = "roles/run.invoker"
    members = ["allUsers"]
  }
}
```


This configuration grants all users permission to invoke the Cloud Run service.

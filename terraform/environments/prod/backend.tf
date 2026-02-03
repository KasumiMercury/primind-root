terraform {
  backend "gcs" {
    # Bucket name is configured via -backend-config during terraform init
    # Example: terraform init -backend-config="bucket=primind-tfstate-<project-id>"
    prefix = "terraform/state/prod"
  }
}

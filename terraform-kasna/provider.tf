terraform {
  required_providers {
    google-beta = "~> 4.5.0" # https://github.com/terraform-providers/terraform-provider-google/releases
    google      = "~> 4.5.0" # https://github.com/terraform-providers/terraform-provider-google-beta/releases
    null = {
        source = "hashicorp/null"
        version = "3.1.0"
    }
  }
}
resource "random_string" "project-suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "google_project" "project" {
  name       = "Wild Workouts"
  folder_id  = var.folder_id
  project_id = "${var.project_name}-${random_string.project-suffix.result}"
  billing_account = var.billing_account
}

resource "google_project_service" "compute" {
  service    = "compute.googleapis.com"
  project = google_project.project.project_id
}

resource "google_project_service" "artifact_registry" {
  service    = "artifactregistry.googleapis.com"
  project = google_project.project.project_id

  disable_dependent_services = true
}

resource "google_project_service" "cloud_run" {
  service    = "run.googleapis.com"
  project = google_project.project.project_id
}

resource "google_project_service" "cloud_build" {
  service    = "cloudbuild.googleapis.com"
  project = google_project.project.project_id
}

resource "google_project_service" "firebase" {
  service    = "firebase.googleapis.com"
  project = google_project.project.project_id

  disable_dependent_services = true
}

resource "google_project_service" "firestore" {
  service    = "firestore.googleapis.com"
  project = google_project.project.project_id
}

resource "google_project_service" "source_repo" {
  service    = "sourcerepo.googleapis.com"
  project = google_project.project.project_id
}

## Artifact Repository
resource "google_artifact_registry_repository" "artifact_repo" {
  provider = google-beta
  project = google_project.project.project_id

  location = var.location
  repository_id = "run-docker-images"
  description = "Cloud Run docker image repository"
  format = "DOCKER"
}

## Cloud Run
module cloud_run_trainer_grpc {
  source = "./service"

  project    = var.project
  location   = var.region
  dependency = null_resource.init_docker_images

  name     = "trainer"
  protocol = "grpc"
}

module cloud_run_trainer_http {
  source = "./service"

  project    = var.project
  location   = var.region
  dependency = null_resource.init_docker_images

  name     = "trainer"
  protocol = "http"
  auth     = false

  envs = [
    {
      name  = "TRAINER_GRPC_ADDR"
      value = module.cloud_run_trainer_grpc.endpoint
    }
  ]
}

module cloud_run_trainings_http {
  source = "./service"

  project    = var.project
  location   = var.region
  dependency = null_resource.init_docker_images

  name     = "trainings"
  protocol = "http"
  auth     = false

  envs = [
    {
      name  = "TRAINER_GRPC_ADDR"
      value = module.cloud_run_trainer_grpc.endpoint
    },
    {
      name  = "USERS_GRPC_ADDR"
      value = module.cloud_run_users_grpc.endpoint
    }
  ]
}

module cloud_run_users_grpc {
  source = "./service"

  project    = var.project
  location   = var.region
  dependency = null_resource.init_docker_images

  name     = "users"
  protocol = "grpc"
}

module cloud_run_users_http {
  source = "./service"

  project    = var.project
  location   = var.region
  dependency = null_resource.init_docker_images

  name     = "users"
  protocol = "http"
  auth     = false

  envs = [
    {
      name  = "USERS_GRPC_ADDR"
      value = module.cloud_run_users_grpc.endpoint
    }
  ]
}

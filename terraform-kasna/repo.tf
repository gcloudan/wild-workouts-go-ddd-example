resource "google_sourcerepo_repository" "wild_workouts" {
  name = var.repository_name
  project = google_project.project.project_id
}

resource "google_cloudbuild_trigger" "trigger" {
  project = google_project.project.project_id

  trigger_template {
    branch_name = "master"
    repo_name   = google_sourcerepo_repository.wild_workouts.name
  }

  filename = "cloudbuild.yaml"
}

# resource "null_resource" "firebase_builder" {
#   provisioner "local-exec" {
#     command = "make firebase_builder"
#   }
# }
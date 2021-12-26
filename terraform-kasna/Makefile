base_image:=gcr.io/cloudrun/hello
load_envs:=. ./.env

all: check

.PHONY: check
check:
	@command -v terraform >/dev/null; echo "✔ Terraform is installed" || ( echo "terraform is not installed"; exit 1 )
	@command -v gcloud >/dev/null; echo "✔ gcloud is installed" || ( echo "gcloud is not installed"; exit 1 )

.PHONY: init
init:
	terraform init

.PHONY: docker_images
docker_images:
	docker pull "${base_image}"

	${load_envs} && for service in trainer trainings users; do \
		tag="australia-southeast1-docker.pkg.dev/$$TF_VAR_project_id/run-docker-images/$$service"; \
		docker tag "${base_image}" "$$tag"; \
		docker push "$$tag"; \
	done
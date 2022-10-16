resource "aws_apprunner_service" "main" {
  service_name = "${var.project_unique_id}-main-service"

  source_configuration {
    image_repository {
      image_configuration {
        runtime_environment_variables = {}
      }
      image_identifier = "public.ecr.aws/aws-containers/hello-app-runner:latest"
      image_repository_type = "ECR_PUBLIC"
    }
    auto_deployments_enabled = false
  }
}
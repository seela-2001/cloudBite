terraform {
  backend "s3" {
    bucket         = "cloud-bite-state-file"
    key            = "terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "cloudbite-terraform-locks"
  }
}
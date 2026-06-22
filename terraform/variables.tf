variable "aws_region" {
  default = "eu-north-1"
}

variable "bucket_name" {
  default = "cloud-bite-state-file"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "cluster_name" {
  default = "cloudbite-eks"
}

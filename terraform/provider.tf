terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_eks_cluster_auth" "cloudbite" {
  name = aws_eks_cluster.cloudbite.name
}

provider "kubernetes" {
  host = aws_eks_cluster.cloudbite.endpoint
  cluster_ca_certificate = base64decode(
    aws_eks_cluster.cloudbite.certificate_authority[0].data
  )

  token = data.aws_eks_cluster_auth.cloudbite.token
}

provider "helm" {
  kubernetes {
    host = aws_eks_cluster.cloudbite.endpoint
    cluster_ca_certificate = base64decode(
      aws_eks_cluster.cloudbite.certificate_authority[0].data
    )

    token = data.aws_eks_cluster_auth.cloudbite.token
  }
}
resource "aws_eks_node_group" "cloudbite" {
  cluster_name    = aws_eks_cluster.cloudbite.name
  node_group_name = "cloudbite-workers"
  node_role_arn   = aws_iam_role.node_group_role.arn
  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  instance_types = ["t3.medium"]

  scaling_config {
    desired_size = 3
    min_size     = 2
    max_size     = 4
  }

  depends_on = [
    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.cni_policy,
    aws_iam_role_policy_attachment.ecr_readonly_policy
  ]

  tags = {
    Name = "cloudbite-workers"
  }
}
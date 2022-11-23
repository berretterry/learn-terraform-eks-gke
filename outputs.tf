output "public_ip" {
value = aws_instance.eks_bastion.public_ip
}

output "private_ip" {
value = aws_instance.eks_bastion.private_ip
}

output "cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}
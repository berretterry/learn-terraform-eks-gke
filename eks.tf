resource "aws_eks_cluster" "learn_eks_cluster" {
    name = "learn_eks_cluster"
    role_arn = aws_iam_role.eks-iam-role.arn

    vpc_config {
      subnet_ids = aws_subnet.public_subnet.0.id
    }
    
    depends_on = [
      aws_iam_role.eks-iam-role,
    ]
}

resource "aws_eks_node_group" "worker_node_group" {
    cluster_name = aws_eks_cluster.learn_eks_cluster.name
    node_group_name = "learn_eks_workernodes"
    node_role_arn = aws_iam_role.workernodes.arn
    subnet_ids = aws_subnet.public_subnet.0.id
    instance_types = ["t3.micro"]

    scaling_config {
      desired_size = 3
      max_size = 3
      min_size = 1
    }

    depends_on = [
       aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
       aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
       #aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    ]
}
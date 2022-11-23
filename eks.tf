#cluster
resource "aws_eks_cluster" "eks_cluster" {
    name = "eks_cluster"
    role_arn = aws_iam_role.cluster.arn

    vpc_config {
        subnet_ids = flatten([aws_subnet.public[*].id, aws_subnet.private[*].id])
        endpoint_private_access = true
        endpoint_public_access = true
        public_access_cidrs = ["0.0.0.0/0"]
    }
    
    depends_on = [
      aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy
    ]
}
#cluster iam role
resource "aws_iam_role" "cluster" {
  name = "eks-Cluster-Role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.cluster.name

}

#worker nodes

resource "aws_eks_node_group" "worker_node_group" {
    cluster_name = aws_eks_cluster.eks_cluster.name
    node_group_name = "eks_workernodes"
    node_role_arn = aws_iam_role.nodes.arn
    subnet_ids = aws_subnet.private[*].id
    instance_types = ["t3.micro"]
    ami = "ami-04a616933df665b44"
    capacity_type = "ON_DEMAND"
    disk_size = 20

    scaling_config {
      desired_size = 3
      max_size = 3
      min_size = 1
    }

    depends_on = [
       aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
       aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
       aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    ]
}
#EKS node iam role
resource "aws_iam_role" "node" {
  name = "${var.project}-Worker-Role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.node.name
  
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node.name
}


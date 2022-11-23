resource "aws_security_group" "public_sg" { 
    name_prefix = "eks_public_group"
    vpc_id = aws_vpc.eks_vpc.id
    description = "security groupp for eks workers"

    tags = {
      "Name" = "Public security group"
    }

}

resource "aws_security_group_rule" "public_in_ssh" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.public_sg.id

}

resource "aws_security_group_rule" "public_in_https" {

    type = "ingress" 
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.public_sg.id
    
}

resource "aws_security_group_rule" "public_out" {
    type             = "egress" 
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    security_group_id = aws_security_group.public_sg.id

}

#data plane? security group and rules
resource "aws_security_group" "data_plane_sg" {
    name = "eks_data_plane_sg"
    vpc_id = aws_vpc.eks_vpc.id
    
    tags = {
      "Name" = "eks_data_plane_sg"
    }
  
}

resource "aws_security_group_rule" "nodes" {
    description = "Allow Nodes to communicate with each other"
    security_group_id = aws_security_group.data_plane_sg.id
    type = "ingress"
    from_port = 0
    to_port = 65535
    protocol = "-1"
    cidr_blocks = var.private_subnets
  
}

resource "aws_security_group_rule" "nodes_inbound" {
    description = "Allow worker kublets and pods to recive coms from the cluster control plane"
    security_group_id = aws_security_group.data_plane_sg.id
    type = "ingress"
    from_port = 1025
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = var.private_subnets
  
}

resource "aws_security_group_rule" "node_outbound" {
    security_group_id = aws_security_group.data_plane_sg.id
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  
}

resource "aws_security_group" "control_plane_sg" {
    name = "eks_controlplane_sg"
    vpc_id = aws_vpc.eks_vpc.id

    tags = {
      "name" = "control-plane-sg"
    }
  
}

#traffic rules?
resource "aws_security_group_rule" "control_plane_inbound" {
    security_group_id = aws_security_group.control_plane_sg.id
    type = "ingress"
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = var.private_subnets
  
}

resource "aws_security_group_rule" "control_plane_outbound" {
    security_group_id = aws_security_group.control_plane_sg.id
    type = "egress"
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = var.private_subnets
  
}

#EKS Security Group
resource "aws_security_group" "eks_cluster" {
    name = "eks-cluster-sg"
    description = "Cluster communication with works nodes"
    vpc_id = aws_vpc.eks_vpc.id
    
    tags = {
      "Name" = "eks-cluster-sg"
    }
  
}

resource "aws_security_group_rule" "cluster_inbound" {
    description = "allow worker nodes to communicate with the cluster api server"
    from_port = 443
    protocol = "tcp"
    security_group_id = aws_security_group.eks_cluster.id
    source_security_group_id = aws_security_group_rule.nodes.id
    to_port = 443
    type = "ingress"
  
}

resource "aws_security_group_rule" "cluster_outbound" {
    description = "allow cluster api server to communicate with the worker nodes"
    from_port = 1024
    protocol = "tcp"
    security_group_id = aws_eks_cluster.eks_cluster.id
    source_security_group_id = aws_security_group_rule.nodes.id
    to_port = 65535
    type = "egress"
  
}

#EKS Node Security Group
resource "aws_security_group" "eks_nodes" {
    name = "eks_node_sg"
    description = "security group for nodes in the cluster"
    vpc_id = aws_vpc.eks_vpc.id
    
   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags = {
      "Name" = "eks-node-sg"
    }
}

resource "aws_security_group_rule" "nodes_internal" {
    description = "allow nodes to communicate with each other"
    from_port = 0
    protocol = "-1"
    security_group_id = aws_security_group.eks_nodes.id
    source_security_group_id = aws_security_group.eks_nodes.id
    to_port = 65535
    type = "ingress"
  
}

resource "aws_security_group_rule" "nodes_cluster_inbound" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_cluster.id
  to_port                  = 65535
  type                     = "ingress"
}
resource "aws_security_group" "worker_group" { 
    name_prefix = "worker_group"
    vpc_id = aws_vpc.eks_vpc.id
    description = "security groupp for eks workers"

}

resource "aws_security_group_rule" "public_in_ssh" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.worker_group.id

}

resource "aws_security_group_rule" "public_in_https" {

    type = "ingress" 
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.worker_group.id
    
}

resource "aws_security_group_rule" "public_out" {
    type             = "egress" 
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    security_group_id = aws_security_group.worker_group.id

}
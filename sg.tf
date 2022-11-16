resource "aws_security_group" "worker_group" { 
    name_prefix = "worker_group"
    vpc_id = aws_vpc.eks_vpc.id
    description = "security groupp for eks workers"

    ingress = {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_block = ["0.0.0.0/0"]
    } 

    ingress = {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_block = ["0.0.0.0/0"]
    } 

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

}
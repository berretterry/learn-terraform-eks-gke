resource "aws_instance" "eks_bastion" {
    ami = "ami-04a616933df665b44"
    instance_type = "t2.micro"
    security_groups = aws_security_group.worker_group.id
    subnet_id = element(aws_subnet.public_subnet.*.id,count.index)
    associate_public_ip_address = true
    tags = {
        "Name" = "EKS-Bastion"
    }
  
}
resource "aws_instance" "eks_bastion" {
    ami = "ami-04a616933df665b44"
    instance_type = "t2.micro"
    security_groups = aws_security_group.worker_group.id
    subnet_ids = element(aws_subnet.public_subnet.*.id,count.index)
    associate_public_ip_address = true
    tags = {
        "Name" = "EKS-Bastion"
    }
  


    provisioner "file" {
        source = "eks_bastion_ssh.pem"
        destination = "/home/ec2-user/eks_bastion_ssh.pem"
        connection = {
            type = "ssh"
            user = "ec2-user"
            private_key = file("eks_bastion_ssh.pem")
            host = self.map_public_ip

        }
    }
    provisioner "remote-exec" {
        inline = ["chmod 400 ~/eks_bastion_ssh.pem"]
        connection {
            type = "ssh"
            user = "ec2-user"
            private_key = "file(eks_bastion_ssh.pem)"
            host = self.public.ip
        }

    }

}

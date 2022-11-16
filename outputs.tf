#output "ssh_keypair" {
#value = eks_bastion_ssh.key.private_key_pem
#sensitive = true
#}
#output "key_name" {
#value = aws_key_pair.key_pair.key_name
#}
output "public_ip" {
value = aws_instance.eks_bastion.public_ip
}
output "private_ip" {
value = aws_instance.eks_bastion.private_ip
}
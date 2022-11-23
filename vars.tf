variable "region" {
    default = "us-west-2"
}
variable "vpc_cidr" {
    default = "10.0.0.0/16"
}
variable "public_subnets" {
    type = list
    default = ["10.0.16.0/20", "10.0.32.0/20", "10.0.48.0/20", "10.0.64.0/20"]
}
variable "private_subnets" {
    type = list
    default = ["10.0.80.0/20", "10.0.96.0/20", "10.0.112.0/20", "10.0.128.0/20"]
}
variable "azs" {
    type = list
    default = ["us-west-2a", "us-west-2b", "us-west-2c", "us-west-2d"]
}
#variable "AWS_ACCESS_KEY" {}
#variable "AWS_SECRET_KEY" {}

    
  

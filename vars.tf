variable "region" {
    default = "us-west-2"
}
variable "vpc_cidr" {
    default = "10.16.0.0/16"
}
variable "subnets_cidr" {
    type = list
    default = ["10.16.0.0/18", "10.16.64.0/18", "10.16.128.0/18", "10.16.192.0/18"]
}
variable "azs" {
    type = list
    default = ["us-west-2a", "us-west-2b", "us-west-2c", "us-west-2d"]
}
#variable "AWS_ACCESS_KEY" {}
#variable "AWS_SECRET_KEY" {}
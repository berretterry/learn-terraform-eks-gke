resource "aws_vpc" "eks_vpc" {
    cidr_block = var.vpc_cidr

    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
      "Name" = "eks_vpc"
    }
  
}

resource "aws_internet_gateway" "eks_igw" {
    vpc_id = aws_vpc.eks_vpc.id
    tags = {
        Name = "internetGateway"
    }
    depends_on = [
      aws_vpc.eks_vpc
    ]
}

resource "aws_subnet" "public" {
    count = length(var.azs)
    vpc_id = aws_vpc.eks_vpc.id
    cidr_block = element(var.public_subnets,count.index)
    availability_zone = element(var.azs,count.index)
    map_public_ip_on_launch = true 
    tags = {
        Name = "Subnet-$(count.index+1)"
    }

}

resource "aws_subnet" "private" {
    count = length(var.azs)
    vpc_id = aws_vpc.eks_vpc.id
    cidr_block = element(var.private_subnets,count.index)
    availability_zone = element(var.azs,count.index)
    map_public_ip_on_launch = true 
    tags = {
        Name = "sg-$(count.index+1)"
    }

}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.eks_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.eks_igw.id
    }
    tags = {
        Name = "publicRouteTable"
    }
  
}

resource "aws_route_table_association" "internet_access" {
    count = length(var.azs)
    subnet_id = element(aws_subnet.public[*].id,count.index)
    route_table_id = aws_route_table.public_rt.id
  
}

resource "aws_eip" "eks_eip" {
    vpc = true
  
    tags = {
      "Name" = "eks_eip"
    }
}

resource "aws_nat_gateway" "eks_nat_gateway" {
    allocation_id = aws_eip.eks_eip.id
    subnet_id = aws_subnet.public[0].id

    tags = {
      "Name" = "eks_nat_gateway"
    }
  
}

resource "aws_route" "private_route" {
    route_table_id = aws_route_table.public_rt.id
    nat_gateway_id = aws_nat_gateway.eks_nat_gateway.id
    destination_cidr_block = "0.0.0.0/0"
  
}
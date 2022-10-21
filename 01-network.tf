resource "aws_vpc" "olw_vpc" {
    cidr_block = var.VPC_CIDR_BLOCK
    enable_dns_hostnames = true
    tags = {
        Name = "olw_vpc"
    }
}

resource "aws_internet_gateway" "olw_igw" {
    vpc_id = aws_vpc.olw_vpc.id
    tags = {
        Name = "olw_igw"
    }
}

resource "aws_subnet" "olw_public_subnet" {
    count = var.SUBNET_COUNT.public
    vpc_id = aws_vpc.olw_vpc.id
    cidr_block = var.PUBLIC_SUBNET_CIDR_BLOCKS[count.index]
    availability_zone = data.aws_availability_zones.available.names[count.index]
    tags = {
        Name = "olw_public_subnet_${count.index}"
    }
}

resource "aws_subnet" "olw_private_subnet" {
    count = var.SUBNET_COUNT.private
    vpc_id = aws_vpc.olw_vpc.id
    cidr_block = var.PRIVATE_SUBNET_CIDR_BLOCKS[count.index]
    availability_zone = data.aws_availability_zones.available.names[count.index]
    tags = {
        Name = "olw_private_subnet_${count.index}"
    }
}

resource "aws_route_table" "olw_public_rt" {
    vpc_id = aws_vpc.olw_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.olw_igw.id
    }
}

resource "aws_route_table_association" "olw_public_assoc" {
    count = var.SUBNET_COUNT.public
    route_table_id = aws_route_table.olw_public_rt.id
    subnet_id = aws_subnet.olw_public_subnet[count.index].id
}

resource "aws_route_table" "olw_private_rt" {
    vpc_id = aws_vpc.olw_vpc.id
}

resource "aws_route_table_association" "olw_private_assoc" {
    count = var.SUBNET_COUNT.private
    route_table_id = aws_route_table.olw_private_rt.id
    subnet_id = aws_subnet.olw_private_subnet[count.index].id
}

resource "aws_security_group" "olw_web_sg" {
    name = "olw_web_sg"
    description = "Security group for OLW web servers"
    vpc_id = aws_vpc.olw_vpc.id

    ingress {
        description = "Allow all traffic through HTTP"
        from_port = "80"
        to_port = "80"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allow SSH connection"
        from_port = "22"
        to_port = "22"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "Allow all outbound traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "olw_web_sg"
    }


}

resource "aws_security_group" "olw_db_sg" {
    name = "olw_db_sg"
    description = "Security group for OLW databases"
    vpc_id = aws_vpc.olw_vpc.id

    ingress {
        description = "Allow MySQL traffic from only olw_web_sg"
        from_port = "3306"
        to_port = "3306"
        protocol = "tcp"
        security_groups = [aws_security_group.olw_web_sg.id]
    }

    tags = {
        Name = "olw_db_sg"
    }
}
resource "aws_key_pair" "olw_kp" {
    key_name = "olw_kp"
    public_key = file("./.pk/olw_pk.pub")
}

data "aws_ami" "ubuntu" {
    most_recent = "true"
    
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]
}

resource "aws_instance" "olw_web" {
    count = var.SETTINGS.web_app.count
    ami = data.aws_ami.ubuntu.id
    instance_type = var.SETTINGS.web_app.instance_type
    subnet_id = aws_subnet.olw_public_subnet[count.index].id
    key_name = aws_key_pair.olw_kp.key_name
    vpc_security_group_ids = [aws_security_group.olw_web_sg.id]

    tags = {
        Name = "olw_web_${count.index}"
        Project = "olw"
    }
}

resource "aws_eip" "olw_web_eip" {
    count = var.SETTINGS.web_app.count
    instance = aws_instance.olw_web[count.index].id
    vpc = true

    tags = {
        Name = "olw_web_eip_${count.index}"
        Project = "olw"
    }
}


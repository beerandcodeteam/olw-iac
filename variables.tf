variable "AWS_REGION" {
    description = "where my resources will be created in"
    type = string
    default = "us-east-2"
}

variable "VPC_CIDR_BLOCK" {
    description = "IP CIDR block for the VPC"
    type = string
    default = "10.0.0.0/16"
}

variable "SUBNET_COUNT" {
    description = "number of public/private subnets"
    type = map(number)
    default = {
        public = 1,
        private = 2
    }
}

variable "PUBLIC_SUBNET_CIDR_BLOCKS" {
    description = "Available IP CIDR blocks for the public subnet"
    type = list(string)
    default = [
        "10.0.1.0/24",
        "10.0.2.0/24",
        "10.0.3.0/24",
        "10.0.4.0/24",
    ]
}

variable "PRIVATE_SUBNET_CIDR_BLOCKS" {
    description = "Available IP CIDR blocks for private subnets"
    type = list(string)
    default = [
        "10.0.101.0/24",
        "10.0.102.0/24",
        "10.0.103.0/24",
        "10.0.104.0/24",
    ]
}

variable "SETTINGS" {
    description = "settings for RDS and EC2 instances"
    type = map(any)
    default = {
        "database" = {
            allocated_storage = 20 //in GB
            engine = "mysql" //db type
            engine_version = "8.0.28" //sgbd version
            instance_class = "db.t2.micro" //instance type
            db_name = "olw" //default database name
            skip_final_snapshot = true
        },
        "web_app" = {
            count = 1 //number of instances
            instance_type = "t2.micro" //instance type
        }
    }
}

variable "DB_USERNAME" {
    description = "Database main user"
    type = string
    sensitive = true
}

variable "DB_PASSWORD" {
    description = "Database main user password"
    type = string
    sensitive = true
}

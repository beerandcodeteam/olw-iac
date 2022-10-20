resource "aws_db_subnet_group" "olw_db_subnet_group" {
    name = "olw_db_subnet_group"
    description = "DB subnet group OLW"

    subnet_ids = [for subnet in aws_subnet.olw_private_subnet : subnet.id]
}

# resource "aws_db_instance" "olw_database" {
#     allocated_storage = var.SETTINGS.database.allocated_storage
#     engine = var.SETTINGS.database.engine
#     engine_version = var.SETTINGS.database.engine_version
#     instance_class = var.SETTINGS.database.instance_class
#     db_name = var.SETTINGS.database.db_name
#     username = var.DB_USERNAME
#     password = var.DB_PASSWORD
#     db_subnet_group_name = aws_db_subnet_group.olw_db_subnet_group.id
#     vpc_security_group_ids = [aws_security_group.olw_db_sg.id]
#     skip_final_snapshot = var.SETTINGS.database.skip_final_snapshot

#     tags = {
#         Name = "olw_database",
#         Project = "olw"
#     }
# }
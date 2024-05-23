# rds
module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.3.1"

  identifier = "${var.global_prefix}-db"

  engine            = "mysql"
  engine_version    = var.engine_version
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = "warp_db"
  username = "${var.global_prefix}_user"

  manage_master_user_password = false
  password                    = random_password.db_password.result
  port                        = "3306"

  iam_database_authentication_enabled = true

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval    = "30"
  monitoring_role_name   = "MyRDSMonitoringRole"
  create_monitoring_role = true
  ca_cert_identifier     = "rds-ca-rsa2048-g1"

  tags = {
    Project     = var.global_prefix
  }

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids           = aws_db_subnet_group.main.subnet_ids

  # DB parameter group
  family = var.db_family

  # DB option group
  major_engine_version = var.major_engine_version

  # Database Deletion Protection
  deletion_protection = true

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]
}

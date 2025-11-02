resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t4g.micro"
  username             = "admin"
  password             = "vihana123"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.dev_sub_group.id
  vpc_security_group_ids = [aws_security_group.dev.id]

  # Backup configuration
  backup_retention_period = 7                      # keep backups for 7 days
  backup_window = "03:00-04:00"          # daily backup time (UTC)

  # Monitoring
  monitoring_interval    = 60 
  monitoring_role_arn = aws_iam_role.rds_monitoring_role.arn
  maintenance_window = "sun:04:00-sun:05:00" # UTC

}

# subnet group 
resource "aws_db_subnet_group" "dev_sub_group" {
  name = "mydb-subnet-group"
  subnet_ids = [ aws_subnet.dev_private.id, aws_subnet.dev_private-1b.id]
  tags = {
    Name = "mydb-subnet-group"
  }
}




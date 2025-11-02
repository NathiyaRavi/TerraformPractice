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
  vpc_security_group_ids = [aws_security_group.db_sg.id]

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
  subnet_ids = [ "subnet-0b161b9900dc8ccec", "subnet-0dc3e14da6a7a9996" ]
  tags = {
    Name = "mydb-subnet-group"
  }
}

# db security group
resource "aws_security_group" "db_sg" {
  name        = "rds-sg"
  description = "Allow DB access from app layer"
  vpc_id      = "vpc-02c2d32a6f5d9091c"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    #security_groups = [aws_security_group.app_sg.id] # Allow only from app servers
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


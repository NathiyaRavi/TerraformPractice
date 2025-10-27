resource "aws_db_instance" "read_replica" {
  identifier               = "mydb-replica"
  replicate_source_db      = aws_db_instance.default.arn
  instance_class           = "db.t4g.micro"
  publicly_accessible      = false
  db_subnet_group_name     = aws_db_subnet_group.dev_sub_group.id
  vpc_security_group_ids   = [aws_security_group.db_sg.id]
  auto_minor_version_upgrade = true
  monitoring_interval      = 60
  monitoring_role_arn      = aws_iam_role.rds_monitoring_role.arn
  deletion_protection      = false
  skip_final_snapshot      = true

  tags = {
    Name = "mydb-replica"
    Environment = "dev"
  }
}
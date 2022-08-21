resource "aws_db_subnet_group" "the-mariadb-subnet" {
  name        = "the-mariadb-subnet"
  description = "RelationalDataBase"
  subnet_ids  = [aws_subnet.main-private-a.id, aws_subnet.main-private-b.id]
}

resource "aws_db_parameter_group" "the-mariadb-parameters" {
  name        = "mariadb-paramameters"
  family      = "mariadb10.4"
  description = "MariaDataBase parameter group"

  parameter {
    name  = "max_allowed_packet"
    value = "16777216"
  }
}

resource "aws_db_instance" "mariadatabase" {
  allocated_storage         = 100 
  engine                    = "mariadb"
  engine_version            = "10.4"
  instance_class            = "db.t2.small" 
  identifier                = "mariadb"
  name                      = "mydatabase"     # database name
  username                  = "obi123"           # username
  password                  = var.PASSWORD # password
  db_subnet_group_name      = aws_db_subnet_group.the-mariadb-subnet.name
  parameter_group_name      = aws_db_parameter_group.the-mariadb-parameters.name
  multi_az                  = "false" # set to true to have high availability: 2 instances synchronized with each other
  vpc_security_group_ids    = [aws_security_group.mariadb_allow.id]
  storage_type              = "gp2"
  backup_retention_period   = 30                                          # how long you’re going to keep your backups
  availability_zone         = aws_subnet.main-private-a.availability_zone # prefered AZ
  final_snapshot_identifier = "themariadb-final-snapshot"                    # final snapshot when executing terraform destroy
  tags = {
    Name = "instance12_mdb"
  }
}
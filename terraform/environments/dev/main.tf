data "aws_availability_zones" "available" {
  #checkov:skip=CKV_AWS_394:Dev selects two available AZs in the configured region; the fixed subnet lists keep the deployment at two AZs.
  state = "available"
}

module "network" {
  source = "../../modules/network"

  name               = "${var.project_name}-${var.environment}-network"
  vpc_cidr           = "10.20.0.0/16"
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 2)

  public_subnet_cidrs = [
    "10.20.0.0/24",
    "10.20.1.0/24",
  ]

  app_subnet_cidrs = [
    "10.20.10.0/24",
    "10.20.11.0/24",
  ]

  database_subnet_cidrs = [
    "10.20.20.0/24",
    "10.20.21.0/24",
  ]
}

module "security" {
  source = "../../modules/security"

  name     = "${var.project_name}-${var.environment}"
  vpc_id   = module.network.vpc_id
  app_port = 8080
  vpc_cidr = "10.20.0.0/16"
}

module "alb" {
  source = "../../modules/alb"

  name              = "${var.project_name}-${var.environment}"
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  security_group_id = module.security.alb_security_group_id
  target_port       = 8080
  health_check_path = "/health"
}

module "database" {
  source = "../../modules/database"

  name              = "${var.project_name}-${var.environment}"
  subnet_ids        = module.network.database_subnet_ids
  security_group_id = module.security.database_security_group_id
  database_name     = "catalog_app"
  master_username   = "catalog_admin"
  multi_az          = true
}

module "container_registry" {
  source = "../../modules/container-registry"

  name = "${var.project_name}-${var.environment}"
}

module "compute" {
  source = "../../modules/compute"

  name       = "${var.project_name}-${var.environment}"
  aws_region = var.aws_region

  image_uri      = "${module.container_registry.repository_url}:${var.image_tag}"
  repository_arn = module.container_registry.repository_arn

  subnet_ids            = module.network.app_subnet_ids
  app_security_group_id = module.security.app_security_group_id
  target_group_arn      = module.alb.target_group_arn

  database_address    = module.database.database_address
  database_port       = module.database.database_port
  database_name       = module.database.database_name
  database_secret_arn = module.database.master_user_secret_arn

  database_init_sql_base64 = base64encode(
    file("${path.root}/../../../application/sql/init.sql")
  )

  min_size     = 2
  desired_size = 2
  max_size     = 4
}

module "monitoring" {
  source = "../../modules/monitoring"

  name                   = "${var.project_name}-${var.environment}"
  aws_region             = var.aws_region
  autoscaling_group_name = module.compute.autoscaling_group_name
  load_balancer_arn      = module.alb.load_balancer_arn
  alert_email            = var.alert_email
}
module "networking" {
  source = "./modules/networking"
  project_name = var.project_name
}

module "database" {
  source        = "./modules/database"
  project_name  = var.project_name
}

module "lambda" {
  source             = "./modules/lambda"
  project_name          = var.project_name
  private_subnet_ids    = module.networking.private_subnet_ids
  lambda_sg_id          = module.security_sg.lambda_sg_id
  dynamodb_table_name   = module.database.table_name
  dynamodb_table_arn    = module.database.table_arn
  lambda_zip            = "${path.root}/artifacts/backend.zip"
}
module "waf_cf" {
  source       = "./modules/security"
  project_name = var.project_name
  scope        = "CLOUDFRONT"
  vpc_id       = module.networking.vpc_id
  providers = {
    aws = aws.us_east_1
  }
}

module "cloudfront" {
  source          = "./modules/cloudfront"
  project_name    = var.project_name
  s3_domain_name  = module.s3.bucket_domain_name
  acm_cert_arn    = var.acm_cert_arn
  waf_acl_arn     = module.waf_cf.waf_arn
  domain_name    = var.domain_name
}
# module "waf_api" {
#   source       = "./modules/security"
#   project_name = var.project_name
#   scope        = "REGIONAL"
#   vpc_id       = module.networking.vpc_id
# }
module "security" {
  source       = "./modules/security"
  project_name = var.project_name
  vpc_id       = module.networking.vpc_id
  scope = "REGIONAL"
}
module "s3" {
  source       = "./modules/s3"
  project_name = var.project_name
  cloudfront_arn = module.cloudfront.cloudfront_arn
}
module "api_gateway" {
  source        = "./modules/api-gateway"
  project_name  = var.project_name
  lambda_arn    = module.lambda.lambda_arn
  lambda_name   = module.lambda.lambda_name
  waf_acl_arn   = module.security.waf_arn
}
module "security_sg" {
  source       = "./modules/security-sg"
  project_name = var.project_name
  vpc_id       = module.networking.vpc_id
}
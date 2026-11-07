terraform {
  backend "s3" {
    bucket         = "catalog-web-app-tfstate-781056656186-ap-south-2"
    key            = "catalog-web-app/dev/terraform.tfstate"
    region         = "ap-south-2"
    encrypt        = true
    dynamodb_table = "catalog-web-app-terraform-locks"
    use_lockfile   = true
  }
}
terraform {
  backend "gcs" {
    bucket = "securecloud-tfstate-cypher"
    prefix = "dev"
  }
}
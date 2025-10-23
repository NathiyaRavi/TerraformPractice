terraform {
  backend "s3" {
    bucket = "terraform-test-nathiya"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}

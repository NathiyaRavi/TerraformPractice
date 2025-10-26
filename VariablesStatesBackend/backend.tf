
terraform {
   backend "s3" {
     encrypt        = true
     bucket         = "terraform-test-nathiya"
     dynamodb_table = "terraform-state-lock-dynamo"
     key            = "terraform.tfstate"
     region         = "ap-south-1"
   }

   ## ...
}

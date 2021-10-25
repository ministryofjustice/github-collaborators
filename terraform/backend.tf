terraform {
  backend "s3" {
    bucket         = "cloud-platform-36623f774b9641d8697d65bdf6b030f5"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "cp-b6970ba60ed66537"
  }
}

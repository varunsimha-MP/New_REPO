terraform {
  backend "s3" {
    region = "ap-southeast-1"
    key = "terraform.state"
    bucket = "terraform-devops-backend-file"
    encrypt = true
    use_lockfile = true
  }
}
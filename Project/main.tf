provider "aws" {
  region = "us-east-1"
}
variable "code_commit_repo" {}

variable "instance_type" {
  default = "t2.micro"
  type    = string
}

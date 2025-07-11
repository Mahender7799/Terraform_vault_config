provider "aws" {
  region = "us-east-1"
}

provider "vault" {
  address = "http://44.210.130.255:8100"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "8ca2c3b3-9606-fc9c-cf77-00af7ce01e06"
      secret_id = "76e44332-1584-5f8c-e9a2-490d0f4fa5ac"
    }
  }
}


data "vault_kv_secret_v2" "example" {
  mount = "secret" // change it according to your mount
  name  = "test-secret" // change it according to your secret
}


resource "aws_instance" "my_instance" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"

  tags = {
    Name = "test"
    Secret = data.vault_kv_secret_v2.example.data["username"]
  }
}

provider "aws" {
  region = "us-west-2"
}

variable "team-name" {
  description = "team-name"
  type        = string
  default     = "default-team-name"
}

resource "aws_instance" "web" {
  ami           = "ami-040d69dfe52dc794d"
  instance_type = "t2.micro"

  tags = {
    Name = var.team-name
  }
}

output "public_ip" {
  value       = aws_instance.web.public_ip
  description = "Public IP of the instance"
}

terraform {
   backend "s3" {
 # Replace this with your bucket name!
   bucket         = "ot-infra-state"
   key            = "global/s3/team1/terraform-test.tfstate"
   region         = "us-east-1"
   }
}

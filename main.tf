provider "aws" {
  profile = "terraform"
  # region is defined in the profile at ~/.aws/config
}

resource "aws_instance" "example" {
  ami           = "ami-087f352c165340ea1"
  instance_type = "t2.micro"

  tags = {
    Name = "tf-example"
  }
}

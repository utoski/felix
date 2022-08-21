variable "AWS_REGION" {
  default = "us-east-1"
}

variable "AWS_ACESS_KEY" {
    default = ""
  }

  variable "AWS_SECRET_KEY" {
    default = ""

  }


variable "cidr_block" {
    type = list(string)
    default = ["10.0.0.0/16", "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "PRIVATE_KEY" {
  default = ""
}

variable "PUBLIC_KEY" {
  default = ""
}

variable "PASSWORD" {
    default = ""
}







 
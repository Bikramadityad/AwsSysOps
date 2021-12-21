variable "region" {
  type    = string
  default = "us-west-2"
}
variable "ami_id" {
  type = map
  default = {
    us-east-1    = "ami-035b3c7efe6d061d5"
    us-west-2    = "ami-074251216af698218"
    eu-central-1 = "ami-9787h5h6nsn"
  }
}

variable "access_key" {
  type    = string
  default = "deleted while uploading"
}

variable "secret_key" {
  type    = string
  default = "deleted while uploading
"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "role_name" {
  type    = string
  default = "s3_ec2"
}


variable "web_sg" {
  type    = string
  default = "sg-0d6f05e4cea1ddf4e"
}

variable "db_sg" {
  type    = string
  default = "sg-0ac0df8e803029815"
}

variable "key_name" {
  type    = string
  default = "linux-oregon-key"
}


variable "pubsub_id" {
  type    = string
  default = "subnet-0a3e8ed5f284461d9"
}

variable "privsub_id" {
  type    = string
  default = "subnet-013357fd480a85f7d"
}




























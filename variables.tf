variable "region" {
  default = "us-east-1"
}

variable "protocol_tcp" {
  default = "tcp"
}

variable "protocol_any" {
  default = "-1"
}

variable "service_ssh" {
  default = 22
}

variable "service_http" {
  default = 80
}

variable "service_any" {
  default = 0
}

variable "cidr_block_vpc_prd" {
  default = "10.0.0.0/16"
}

variable "cidr_block_public_subnet" {
  default = "10.0.1.0/24"
}

variable "cidr_blocks_any" {
  default = "0.0.0.0/0"
}

variable "webserver_ami" {
  default = "ami-007855ac798b5175e"

}

variable "webserver_instance_type" {
  default = "t2.micro"

}

variable "user" {
  default = "ubuntu"
}

variable "key_name" {
  default = "kf"
}

data "http" "meu_ip" {
  url = "https://checkip.amazonaws.com/"
}

locals {
  project_name        = "secure-web"
  env                 = "dev"
  region              = "us-east-1"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"


  instance_type_web   = "t3.micro"
  instance_type_bastion = "t3.micro"
  ami_id              = "ami-0c55b159cbfafe1f0" 
  allowed_admin_cidr  = "${trimspace(data.http.meu_ip.response_body)}/32"

  db_engine           = "postgres"
  db_engine_version   = "15.5"
  db_instance_class   = "db.t3.micro"
  db_name             = "appdb"
  db_username         = "adminuser"
}

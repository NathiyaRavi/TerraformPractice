module "localtemp" {
    source = "./ModuleTemplate"
    key_name = var.key_name
    ami = var.ami
    instance_type = var.instance_type
  
}
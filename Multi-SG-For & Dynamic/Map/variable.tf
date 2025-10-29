variable "ingress_rules" {
    description = "ingress rules in map"
    type = map(object({
    port  = number
    cidrs = list(string)
  }))

  default = {
    ssh = {
      port  = 22
      cidrs = ["203.0.113.10/32"] # only office IP
    }
    http = {
      port  = 80
      cidrs = ["0.0.0.0/0"]       # open to everyone
    }
    mysql = {
      port  = 3306
      cidrs = ["10.0.0.0/16"]     # internal only
    }
  }
  
}
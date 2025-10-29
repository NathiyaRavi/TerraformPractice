variable "ingress_ports" {
  description = "List of ports to allow inbound access"
  type        = list(number)
  default     = [22, 80, 3306]
}
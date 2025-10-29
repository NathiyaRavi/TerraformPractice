resource "aws_instance" "name" {
  ami = "ami-06fa3f12191aa3337"
  instance_type = "t3.micro"
    #   count = 2 # this is a hardcode value for count, but we cannot alter the values based on index
    # count = length(var.env) # to modify the value based on index we can use list type variable with index, but in destroy case it will delete from highest count
    for_each = toset(var.env) # we can use foreach to iterate properly 
    tags = {
    #   Name = var.env[count.index]
    Name = each.value
    }
}
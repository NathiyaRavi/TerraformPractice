Variables:

1. Hardcoded value in main file
    it will work if we don't have terraform.tfvars
2. Hardcoded value in variables file
    it will also work only if we don't have terraform.tfvars
3. Default file (terrform.tfvar):
    We can use this to place all vars in one single file

4. Env based files like dev.tfvars, test.tfvars
    We need to mention in the cli in the plan and apply command

    terraform plan -var-file="dev.tfvars"

    if we no mention -var-file, it will take default file

5. we can provide var value in cmd inline itself, it will take waitage than others
   
    terraform plan -var="instance_type=t3.micro"

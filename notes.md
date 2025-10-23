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


STATE FILE:

1. IF 2 Dev have same state file by sharing manually
    1. conflicts will occur
    2. overwrite changes

2. IF diff state files means on the same task
    1. duplicate resources will be created
SOLUTION: Remote Backend using S3,
          ---- git pull is always must to get latest code
          Drawback: IF 2 devs are working at the same time, state lock and merge conflicts will occur

          SOLUTION:: DYNAMO DB ( State locking provision )
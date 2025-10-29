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

IMPORT:
--------

1. Control the resources in terraform which has been created manually 
    1. create empty resource block and run the command to create state file
        terraform import aws_instance.import-test i-0afe7e2aad1d1e4c5
    2. refer the state file and add information into resource block, do it until you get the 0 chnages in the plan
   

TARGET:
    To run the terraform command only for the particular resource
    
    terraform plan -target="aws_s3_bucket.test" -target="aws_s3_bucket.test1"
    terraform apply -target="aws_s3_bucket.test" -target="aws_s3_bucket.test1"

PROVISIONING:
-------------
 1. Provide instalaation command inside resource itself
 2. It will run only after resource creation
 3. If we modify any code in the command, it is destroy and recreate the resource each time
 4. No information captured in tfstate

 COUNT:
 -------

 1. If we provide count=2 it will create 2 resources
 2. If we try to use it in the list type variable and try to use the index means, like
    [ "dev", "test", "prod" ]
    It will create 3 servers
    If I remove "test" in between, now the index size is 2, so it will remove it from end only.

SOLUTION: FOR-EACH with set, now we can use each.value and it will iterate properly



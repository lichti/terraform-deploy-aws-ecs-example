# APP Deployment

## Requirements
You must to have intalled in your machine:
 - AWSCLI ([See how to install](http://docs.aws.amazon.com/cli/latest/userguide/installing.html))
 - Docker ([See how to install](https://docs.docker.com/engine/installation/))
 - Docker Compose ([See how to install](https://docs.docker.com/compose/install/))
 - Terraform ([See how to install](https://www.terraform.io/intro/getting-started/install.html))

## Deploying

- You must to export some variables as: 
  - `TF_VAR_aws_access_key` with you aws acces key
  - `TF_VAR_aws_secret_key` with your aws secret key
  - `TF_VAR_admin_cidr` with your public CIDR, to allow ssh access to EC2 Hosts
  - `TF_VAR_token` with Aplication Token

Eg.:
```
 $ export TF_VAR_aws_access_key="xxxxxxxxxxxxxxxxxxxx"
 $ export TF_VAR_aws_secret_key="xxxxxxxx+xxxxxxxxxxxxxxxxxxxx"
 $ export TF_VAR_admin_cidr="0.0.0.0/0" #Allow access to the world
 $ export TF_VAR_token="e594e16a-9781-11e7-a8d3-d7c58a01d7b1"
 ```

 - Now it's simple, just need run the terraform. Eg:
 ```
$ cd terraform
$ terrform init
$ terraform plan -out /tmp/myplay
$ terraform apply /tmp/myplay
 ```

- To test if aplication is working, wil can to do:
```
$ curl -i -H "Authorization: Token ${TF_VAR_token}" $(terraform output | grep alb_hostname | cut -d= -f2) 
```
Output
```
HTTP/1.1 200 OK
Date: Tue, 12 Sep 2017 06:37:04 GMT
Content-Type: text/html; charset=utf-8
Content-Length: 27
Connection: keep-alive
Server: Werkzeug/0.12.2 Python/2.7.13

server flying!!%                             
```

- How we want change or destroy this environment other times, we need save the terraform.tfstate file in our repo.
```
$ git add terraform.tfstate
$ git commit -m "Update terraform state file"
```

- To change application Token only need to change the variable TF_VAR_token and run terraform again. Eg:
```
$ export TF_VAR_token="new-token"
$ terraform plan -out /tmp/myplay
$ terraform apply /tmp/myplay
```

- To destroy this environment, we neet to run only this command:
```
$ terraform destroy
```

- After run the `terraform apply`, it will be show on stdout some aws output  variables. If you want to see these again, you can o do:
```
$ terraform output   
```
Output
```
alb_hostname = alb-ecs-app-1411342922.us-east-1.elb.amazonaws.com
asg_id = app-asg
asg_instance_security_group = sg-e3f20190
asg_launch_configuration = terraform-003e11b7b43d0beeb2cba2f305
ecs_cluster_name = my-ecs-cluster
myapp_repository_url = 058683878978.dkr.ecr.us-east-1.amazonaws.com/myapp
myapp_service_desired_count = 1
myapp_task_revision = 17
```

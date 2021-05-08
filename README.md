# Terraform project

1. [Software version](#Software-version)
2. [Hardware version](#Hardware-version)
3. [Run project](#Run-project)
4. [Contributors](#Contributors)

## Software version

* Default AMI: ami-0885b1f6bd170450c
* Spark: 3.0.1
* Hadoop: 2.7.7
* Python: 3.8
* Java: openjdk-8-jdk

## Hardware version

* Default AWS instances: t2.large

## Run project

1. [Download and Install](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started) Terraform


2. Download this project from github.
```bash
git clone https://github.com/martinasalis/Terraform_project.git
```

3. Enter in the Terraform project directory
```bash
cd Terraform_project/
```

4. Login in your AWS account and create a key pairs in **PEM** format.
   Follow [this](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair) guide.
   After you create a key pairs download and save it in ```Terraform_project/``` folder.


5. Open the file ```terraform.tfvars``` and insert your data.
   * If you are using AWS Educate you can retrive your values in the Vocareum page you get after having logged in by clicking on the button "Account Details" under the voice "AWS CLI".
   * If you are using the normal AWS follow the guide on [this](https://aws.amazon.com/it/blogs/security/how-to-find-update-access-keys-password-mfa-aws-management-console/) page in the paragraph called "Generate access keys for programmatic access".
```
access_key="<YOUR ACCESS KEY>"
secret_key="<YOUR SECRET KEY>"
token="<YOUR TOKEN>"
aws_private_key_name="<YOUR KEY NAME>"
aws_private_key_path="<YOUR KEY NAME>.pem"
slaves_count=<NUMBER CLUSTER WORKER>
```

6. Open terminal in ```Terraform_project/``` directory and insert these commands:
```bash
terraform init
terraform apply
```

7. After the cluster is created, the **PUBLIC IP** and **PUBLIC DNS** of the master node are shown.
   Connect to it using this command:
```bash
ssh -i '<YOUR KEY NAME>.pem' ubuntu@<PUBLIC DNS>
```

8. During execution of the project you can control it on the Spark GUI on your browser.
   Connect to ```<PUBLIC IP>:8080```.


9. Now you are ready to execute your application. Use the command below.
   Replace ```your_app.py``` with the name of your application's main file.
```bash
$SPARK_HOME/bin/spark-submit --master spark://namenode:7077 your_app.py
```

10. After the execution is finished, exit from master node and destroy the cluster using this command:
```bash
terraform destroy
```

## Contributors

[Martina Salis](https://github.com/martinasalis) <br/>
[Luca Grassi](https://github.com/Luca14797)

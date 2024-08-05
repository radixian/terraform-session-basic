# terraform-session
#A sample terraform template to kickstart a project.

#Step1: Please clone this repository. You might have to install git first.
#Step2: Run the following commands.

cd terraform-session
chmod u+x ./requirements.sh
sudo ./requirements.sh
cd demo
#add your credentials to terraform.tfvars
terraform init
terraform plan
terraform apply
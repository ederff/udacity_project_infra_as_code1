# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository

2. Authenticate to Azure Provider using Azure CLI

3. Build VM Image using Packer 

    `packer build server.json`

4. Deploy your Infrastructure using terraform

    `terraform init`
    `terraform plan`
    `terraform apply`


### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
- Authentication

    Packer and Terraform can take advantage of your Azure CLI credentials to be able to authenticate to the Azure provider, but you can also provide specific service principal credentials through environment variables.

    ```
    $ export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
    $ export ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
    $ export ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
    $ export ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
    ```

- Custom Image template
    Packer is responsible to build your template image and store it in Azure.
    By default it is going to create a new resource group in "East US" location called "packer-rg", but you can customize that by editing the "server.json" file in this repository, among other parameters according with your needs.
    Then, you can run the image build by running the following packer command.

    `packer build server.json`

- Infrastructure Deployment
    After image building, you will be able to deploy the infrastructure using Terraform.

    - "main.tf" file contains the template for deploying all the resources needed in Azure, including load balancer for the VMS.
    - "vars.tf" file contains customized parameters that you can change default values, or be requested to fill during the deployment execution, like number of vms to deploy, and user name, admin parameters, among others.



    Make sure the variables are correct, and also the required tags "department" and "environment" are filled accordingly.
    Also, if you did any changes on image building, make sure to inform the source image id that you built before using packer to use on VMs deployment. 
    
    After confirming variables values.
    Execute terraform commands below:

    `terraform init` - this is going to initialize and download required terraform resources, like Azure provider.

    `terraform plan -out solution.plan` - this is going to validate your code initially, inform how many changes will be done and it will generate the "solution.plan" file to be used on your "apply" command.

    `terraform apply solution.plan` - This is going to deploy your infrastructure according with your plan.

    
    **Also if you would like to delete your infrastructure, you just need to run:**

    `terraform destroy`

### Output

At the end you will have your complete infrastructure with a Load Balancer in front of your VMs and network configuration and security applied.

Output for terraform plan:

14 to add, 0 to change, 0 to destroy.

Output for terraform apply:

Apply complete! Resources: 14 added, 0 changed, 0 destroyed.


If you face any kind of issue, please open an issue here with output log details.
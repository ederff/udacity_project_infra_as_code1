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

    `terraform plan -out solution.plan`

    `terraform apply solution.plan`


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


    **How to change "vars.tf" file:**


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


Output for `terraform apply "solution.plan"`:

```
azurerm_resource_group.main: Creating...
azurerm_resource_group.main: Creation complete after 3s [id=/subscriptions/e9627484-84d2-439a-a98e-864f434b5356/resourceGroups/testing-rg]
azurerm_virtual_network.main: Creating...
azurerm_public_ip.main: Creating...
azurerm_availability_set.main: Creating...
azurerm_availability_set.main: Creation complete after 6s [id=/subscriptions/e9627484-84d2-439a-a98e-864f434b5356/resourceGroups/testing-rg/providers/Microsoft.Compute/availabilitySets/app-aset]
azurerm_public_ip.main: Creation complete after 8s [id=/subscriptions/e9627484-84d2-439a-a98e-864f434b5356/resourceGroups/testing-rg/providers/Microsoft.Network/publicIPAddresses/testing-publicIP]
azurerm_lb.main: Creating...
azurerm_virtual_network.main: Still creating... [10s elapsed]
azurerm_virtual_network.main: Creation complete after 11s [id=/subscriptions/e9627484-84d2-439a-a98e-864f434b5356/resourceGroups/testing-rg/providers/Microsoft.Network/virtualNetworks/testing-network]
azurerm_subnet.main: Creating...
azurerm_lb.main: Creation complete after 6s [id=/subscriptions/e9627484-84d2-439a-a98e-864f434b5356/resourceGroups/testing-rg/providers/Microsoft.Network/loadBalancers/AppLoadBalancer]
azurerm_lb_backend_address_pool.main: Creating...
azurerm_subnet.main: Creation complete after 5s [id=/subscriptions/e9627484-84d2-439a-a98e-864f434b5356/resourceGroups/testing-rg/providers/Microsoft.Network/virtualNetworks/testing-network/subnets/internal]
azurerm_network_interface.main[1]: Creating...
azurerm_network_interface.main[0]: Creating...
azurerm_network_security_group.main: Creating...
azurerm_lb_backend_address_pool.main: Creation complete after 4s [id=/subscriptions/e9627484-84d2-439a-a98e-864f434b5356/resourceGroups/testing-rg/providers/Microsoft.Network/loadBalancers/AppLoadBalancer/backendAddressPools/BackEndAddressPool]
azurerm_network_interface.main[1]: Creation complete after 6s [id=/subscriptions/e9627484-84d2-439a-a98e-864f434b5356/resourceGroups/testing-rg/providers/Microsoft.Network/networkInterfaces/testing-nic-1]
azurerm_network_security_group.main: Creation complete after 10s [id=/subscriptions/e9627484-84d2-439a-a98e-864f434b5356/resourceGroups/testing-rg/providers/Microsoft.Network/networkSecurityGroups/testing-nsg]
azurerm_network_interface.main[0]: Still creating... [10s elapsed]
azurerm_network_interface.main[0]: Creation complete after 10s [id=/subscriptions/e9627484-84d2-439a-a98e-864f434b5356/resourceGroups/testing-rg/providers/Microsoft.Network/networkInterfaces/testing-nic-0]
azurerm_network_interface_backend_address_pool_association.main[0]: Creating...
azurerm_network_interface_backend_address_pool_association.main[1]: Creating...
azurerm_linux_virtual_machine.main[0]: Creating...
azurerm_linux_virtual_machine.main[1]: Creating...
azurerm_network_interface_backend_address_pool_association.main[0]: Creation complete after 4s [id=/subscriptions/e9627484-84d2-439a-a98e-864f434b5356/resourceGroups/testing-rg/providers/Microsoft.Network/networkInterfaces/testing-nic-0/ipConfigurations/internal|/subscriptions/e9627484-84d2-439a-a98e-864f434b5356/resourceGroups/testing-rg/providers/Microsoft.Network/loadBalancers/AppLoadBalancer/backendAddressPools/BackEndAddressPool]
azurerm_network_interface_backend_address_pool_association.main[1]: Creation complete after 4s [id=/subscriptions/e9627484-84d2-439a-a98e-864f434b5356/resourceGroups/testing-rg/providers/Microsoft.Network/networkInterfaces/testing-nic-1/ipConfigurations/internal|/subscriptions/e9627484-84d2-439a-a98e-864f434b5356/resourceGroups/testing-rg/providers/Microsoft.Network/loadBalancers/AppLoadBalancer/backendAddressPools/BackEndAddressPool]
azurerm_linux_virtual_machine.main[0]: Still creating... [10s elapsed]
azurerm_linux_virtual_machine.main[1]: Still creating... [10s elapsed]
azurerm_linux_virtual_machine.main[0]: Still creating... [20s elapsed]
azurerm_linux_virtual_machine.main[1]: Still creating... [20s elapsed]
azurerm_linux_virtual_machine.main[0]: Still creating... [30s elapsed]
azurerm_linux_virtual_machine.main[1]: Still creating... [30s elapsed]
azurerm_linux_virtual_machine.main[0]: Still creating... [40s elapsed]
azurerm_linux_virtual_machine.main[1]: Still creating... [40s elapsed]
azurerm_linux_virtual_machine.main[0]: Still creating... [50s elapsed]
azurerm_linux_virtual_machine.main[1]: Still creating... [50s elapsed]
azurerm_linux_virtual_machine.main[0]: Creation complete after 55s [id=/subscriptions/e9627484-84d2-439a-a98e-864f434b5356/resourceGroups/testing-rg/providers/Microsoft.Compute/virtualMachines/testing-vm-0]
azurerm_linux_virtual_machine.main[1]: Still creating... [1m0s elapsed]
azurerm_linux_virtual_machine.main[1]: Still creating... [1m10s elapsed]
azurerm_linux_virtual_machine.main[1]: Still creating... [1m20s elapsed]
azurerm_linux_virtual_machine.main[1]: Creation complete after 1m26s [id=/subscriptions/e9627484-84d2-439a-a98e-864f434b5356/resourceGroups/testing-rg/providers/Microsoft.Compute/virtualMachines/testing-vm-1]

Apply complete! Resources: 14 added, 0 changed, 0 destroyed.
```


If you face any kind of issue, please open an issue here with output log details.
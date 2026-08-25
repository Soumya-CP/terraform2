# Nous Azure VM

This Terraform configuration creates:

- an Azure resource group named `nous`
- a virtual network and subnet
- a public IP, network security group, and network interface
- a small Ubuntu Linux VM named `nous-vm` using `Standard_B1s`
- a local SSH private key named `nous-vm.pem`

## Deploy

1. Sign in to Azure:

   ```powershell
   az login
   ```

2. Create your variables file and set your Azure subscription ID:

   ```powershell
   Copy-Item terraform.tfvars.example terraform.tfvars
   ```

3. Initialize and review the deployment:

   ```powershell
   terraform init
   terraform plan
   ```

4. Create the resources:

   ```powershell
   terraform apply
   ```

5. Use the `ssh_command` output to connect to the VM.

To delete the resources later, run `terraform destroy`.

> The SSH rule permits port 22 from the internet for this basic example. For a
> production deployment, restrict `source_address_prefix` in `main.tf` to your
> own public IP address.

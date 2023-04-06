# Initialize Terraform
terraform init

# Apply Terraform configuration
terraform apply -auto-approve

# Remove the state for the tls_private_key resource
terraform state rm tls_private_key.pvk

# Delete backup file with pkv data
try {
    Get-ChildItem -Path . -Filter terraform.tfstate.*.backup | Remove-Item
}
catch {
    Write-Error "An error occurred while deleting backup files: $_"
}
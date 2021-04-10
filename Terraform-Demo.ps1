# Terraform-Demo v1
# PowerShell script to do a quick setup of Terraform on Windows for lab/demo purposes 
# 2021 @tanktopLogger - tanktopsecurity.com - github.com/tanktopSecurity

# Download Terrafrom and hash file
Write-Output "Downloading Terraform files"
Invoke-WebRequest -Uri https://releases.hashicorp.com/terraform/0.14.10/terraform_0.14.10_windows_amd64.zip -OutFile C:\users\$env:USERNAME\Downloads\terraform_0.14.10_windows_amd64.zip
Invoke-WebRequest -Uri https://releases.hashicorp.com/terraform/0.14.10/terraform_0.14.10_SHA256SUMS -OutFile C:\users\$env:USERNAME\Downloads\terraform_0.14.10_SHA256SUMS.txt

# Check the filehash
Write-Output "Checking file hash"
$hash = Get-FileHash C:\users\$env:USERNAME\Downloads\terraform_0.14.10_windows_amd64.zip -Algorithm SHA256 | Select-Object -ExpandProperty Hash
$sha256Hash = Select-String -Path C:\users\$env:USERNAME\Downloads\terraform_0.14.10_SHA256SUMS.txt -Pattern $hash

    try {
        $sha256Hash -like $sha256Hash
    }
       
    catch {
        Write-Output "Filehash does not match. Reccomended to not proceed."
    }


# Unzip the zip
Write-Output "Extracting Terraform zip file"
Expand-Archive C:\users\$env:USERNAME\Downloads\terraform_0.14.10_windows_amd64.zip -DestinationPath C:\users\$env:USERNAME\Downloads\terraform_0.14.10_windows_amd64

# Set the PATH environment variable
Write-Output "Setting PATH environemtn variable"
Set-Item -Path Env:Path -Value ($Env:Path + ";C:\Users\$env:USERNAME\Downloads\terraform_0.14.10_windows_amd64")

# Download and install Azure CLI
Write-Output "Downloading and installing Azure CLI - this takes a few minutes"
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile C:\users\$env:USERNAME\Downloads\AzureCLI.msi
Set-Location C:\users\$env:USERNAME\Downloads
Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'

# Create Terraform project folder
Write-Output "Creating Terraform project folder"
New-Item -Path "C:\users\$env:USERNAME\Downloads\terraformDemo" -Name "terraformDemo" -ItemType Directory
Set-Location -Path C:\users\$env:USERNAME\Downloads\terraformDemo

# Download example Terraform config file from tanktop Github
Write-Output "Downloading example Terraform config file"
Invoke-WebRequest -Uri  https://raw.githubusercontent.com/tanktopSecurity/terraformDemo/bbe92820caae6cb5ac80f02410c2c16209a66039/main.tf -OutFile C:\users\$env:USERNAME\Downloads\terraformDemo\main.tf

Write-Output "Setup complete"
Write-Output "Please try to use terrafrom -help to verify setup"

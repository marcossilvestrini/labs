<#
.Synopsis
   Up lab for learning
.DESCRIPTION
   Set folder of virtualbox VM's
   Create a semafore for vagrant up
   Copy public key for vagrant shared folder
   This script is used for create a new lab with vagrant.
   Create all VM's in Vagrantfile
   Copy all private key of VM's for F:\Projetos\vagrant_pk folder
.EXAMPLE
   & vagrant_up_windows.ps1
#>

# Execute script as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))  
{  
  $arguments = "& '" +$myinvocation.mycommand.definition + "'"
  Start-Process -Wait powershell -Verb runAs -WindowStyle Hidden -ArgumentList $arguments
  Break
}

# Clear screen
Clear-Host

#Stop vagrant process
Get-Process -Name *vagrant* | Stop-Process -Force
Get-Process -Name *ruby* | Stop-Process -Force

# Semafore for vagrant process
$scriptPath=$PSScriptRoot
$basePath=($scriptPath | Split-Path -Parent) | Split-Path -Parent
$semafore="$scriptPath\vagrant-up.silvestrini"
New-Item -ItemType File -Path $semafore -Force >$null

# SSH
$ssh_path="$( (($scriptPath | Split-Path -Parent)| Split-Path -Parent) | Split-Path -Parent)\security"
Copy-Item -Force "$env:USERPROFILE\.ssh\id_ecdsa.pub" -Destination $ssh_path

switch ($(hostname)) {   
   "silvestrini" {
      # Desktop Configurations
      Write-Host "Project execution in PC"
      # Variables
      $vagrant="E:\Apps\Vagrant\bin\vagrant.exe"
      $vagrantHome = "E:\Apps\Vagrant\vagrant.d"
      $vagrantPK="F:\Projetos\vagrant-pk"
      $baseVagrantfile="F:\CERTIFICACAO\labs\vagrant\"
      $virtualboxFolder = "E:\Apps\VirtualBox"
      $virtualboxVMFolder = "E:\Servers\VirtualBox"
   }   
   "silvestrini2" {
      # Notebook Configurations
      Write-Host "Project execution in Notebook"
      # Variables
      $vagrant="C:\Cloud\Vagrant\bin\vagrant.exe"
      $vagrantHome = "C:\Cloud\Vagrant\.vagrant.d"
      $vagrantPK="C:\Cloud\Vagrant\vagrant-pk"
      # Write-Host "Create folder: $vagrantPK"
      # if(!(Test-Path $vagrantPK)){New-Item -ItemType Directory $vagrantPK}
      $vagrantPK="F:\Projetos\vagrant-pk"
      $baseVagrantfile="F:\CERTIFICACAO\labs\vagrant"
      $virtualboxFolder = "C:\Program Files\Oracle\VirtualBox"
      $virtualboxVMFolder = "C:\Cloud\VirtualBox"
   }
   Default {Write-Host "This hostname is not available for execution this script!!!";exit 1}
}

# # VirtualBox home directory.
# Start-Process -Wait -NoNewWindow -FilePath "$virtualboxFolder\VBoxManage.exe" `
# -ArgumentList  @("setproperty", "machinefolder", "$virtualboxVMFolder")

# # Vagrant home directory for downloadad boxes.
# setx VAGRANT_HOME "$vagrantHome" >$null

#Up Servers BIND
# $bind = "$baseVagrantfile\linux\dnsbind"
# Set-Location $bind
# Start-Process -Wait -FilePath $vagrant -ArgumentList "up"  -Verb RunAs
# Copy-Item .\.vagrant\machines\ol9-server01\virtualbox\private_key $vagrantPK\ol9-server01
# Copy-Item .\.vagrant\machines\debian-server01\virtualbox\private_key $vagrantPK\debian-server01
# Copy-Item .\.vagrant\machines\debian-server02\virtualbox\private_key $vagrantPK\debian-server02
# Copy-Item .\.vagrant\machines\ol9-server02\virtualbox\private_key $vagrantPK\ol9-server02
# Copy-Item .\.vagrant\machines\ol9-client01\virtualbox\private_key $vagrantPK\ol9-client01

# # Up Servers DHCP
# $dhcp = "$baseVagrantfile\linux\dhcp"
# Set-Location $dhcp
# Start-Process -Wait -WindowStyle Minimized -FilePath $vagrant -ArgumentList "up"  -Verb RunAs
# Copy-Item .\.vagrant\machines\ol9-server01\virtualbox\private_key $vagrantPK\ol9-server01
# Copy-Item .\.vagrant\machines\debian-server01\virtualbox\private_key $vagrantPK\debian-server01
# Copy-Item .\.vagrant\machines\debian-client01\virtualbox\private_key $vagrantPK\debian-client01

# # Up Servers OpenLDAP
# $openldap = "$baseVagrantfile\linux\openldap"
# Set-Location $openldap
# Start-Process -Wait -WindowStyle Minimized -FilePath $vagrant -ArgumentList "up"  -Verb RunAs
# Copy-Item .\.vagrant\machines\ol9-server01\virtualbox\private_key $vagrantPK\ol9-server01
# Copy-Item .\.vagrant\machines\debian-server01\virtualbox\private_key $vagrantPK\debian-server01
# Copy-Item .\.vagrant\machines\debian-client01\virtualbox\private_key $vagrantPK\debian-client01


# # Up Servers Apache
# $apache = "$baseVagrantfile\linux\apache"
# Set-Location $apache
# Start-Process -Wait -WindowStyle Minimized -FilePath $vagrant -ArgumentList "up"  -Verb RunAs
# Copy-Item .\.vagrant\machines\ol9-server01\virtualbox\private_key $vagrantPK\ol9-server01
# Copy-Item .\.vagrant\machines\ol9-server02\virtualbox\private_key $vagrantPK\ol9-server02
# Copy-Item .\.vagrant\machines\debian-server01\virtualbox\private_key $vagrantPK\debian-server01
# Copy-Item .\.vagrant\machines\debian-server02\virtualbox\private_key $vagrantPK\debian-server02
# Copy-Item .\.vagrant\machines\debian-client01\virtualbox\private_key $vagrantPK\debian-client01

# # Up Servers Nginx
# $nginx = "$baseVagrantfile\linux\nginx"
# Set-Location $nginx
# Start-Process -Wait -WindowStyle Minimized -FilePath $vagrant -ArgumentList "up"  -Verb RunAs
# Copy-Item .\.vagrant\machines\ol9-server01\virtualbox\private_key $vagrantPK\ol9-server01
# Copy-Item .\.vagrant\machines\ol9-server02\virtualbox\private_key $vagrantPK\ol9-server02
# Copy-Item .\.vagrant\machines\debian-server01\virtualbox\private_key $vagrantPK\debian-server01
# Copy-Item .\.vagrant\machines\debian-server02\virtualbox\private_key $vagrantPK\debian-server02
# Copy-Item .\.vagrant\machines\debian-client01\virtualbox\private_key $vagrantPK\debian-client01

# # Up Servers Mail
# $mail = "$baseVagrantfile\linux\postfix"
# Set-Location $mail
# Start-Process -Wait -WindowStyle Minimized -FilePath $vagrant -ArgumentList "up"  -Verb RunAs
# Copy-Item .\.vagrant\machines\ol9-server01\virtualbox\private_key $vagrantPK\ol9-server01
# Copy-Item .\.vagrant\machines\debian-client01\virtualbox\private_key $vagrantPK\debian-client01


# # Up Servers Samba
# # After up vms, execute this scripts: create_local_user.ps1,create_share.ps1 for create windows share
# $samba = "$baseVagrantfile\linux\samba"
# Set-Location $samba
# Start-Process -Wait -WindowStyle Minimized -FilePath $vagrant -ArgumentList "up"  -Verb RunAs
# Copy-Item .\.vagrant\machines\ol9-server01\virtualbox\private_key $vagrantPK\ol9-server01
# Copy-Item .\.vagrant\machines\debian-server01\virtualbox\private_key $vagrantPK\debian-server01
# Copy-Item .\.vagrant\machines\debian-client01\virtualbox\private_key $vagrantPK\debian-client01

# # Up Servers NFS
# $nfs = "$baseVagrantfile\linux\nfs"
# Set-Location $nfs
# Start-Process -Wait -WindowStyle Minimized -FilePath $vagrant -ArgumentList "up"  -Verb RunAs
# Copy-Item .\.vagrant\machines\ol9-server01\virtualbox\private_key $vagrantPK\ol9-server01
# Copy-Item .\.vagrant\machines\debian-server01\virtualbox\private_key $vagrantPK\debian-server01
# Copy-Item .\.vagrant\machines\debian-client01\virtualbox\private_key $vagrantPK\debian-client01


# # Up Servers Pure-FTP
# $pureftp = "$baseVagrantfile\linux\pure-ftp"
# Set-Location $pureftp
# Start-Process -Wait -WindowStyle Minimized -FilePath $vagrant -ArgumentList "up"  -Verb RunAs
# Copy-Item .\.vagrant\machines\ol9-server01\virtualbox\private_key $vagrantPK\ol9-server01
# Copy-Item .\.vagrant\machines\debian-server01\virtualbox\private_key $vagrantPK\debian-server01
# Copy-Item .\.vagrant\machines\debian-client01\virtualbox\private_key $vagrantPK\debian-client01

# # Up LINUX lab stack
# $lab = "$baseVagrantfile\linux\lab"
# Set-Location $lab
# Start-Process -Wait -WindowStyle Minimized -FilePath $vagrant -ArgumentList "up"  -Verb RunAs
# Copy-Item .\.vagrant\machines\ol9-server01\virtualbox\private_key $vagrantPK\ol9-server01
# Copy-Item .\.vagrant\machines\ol9-server02\virtualbox\private_key $vagrantPK\ol9-server02
# Copy-Item .\.vagrant\machines\debian-server01\virtualbox\private_key $vagrantPK\debian-server01
# Copy-Item .\.vagrant\machines\debian-server02\virtualbox\private_key $vagrantPK\debian-server02
# Copy-Item .\.vagrant\machines\debian-client01\virtualbox\private_key $vagrantPK\debian-client01

# # Up azure stack
# $azure = "$baseVagrantfile\linux\azure"
# Set-Location $azure
# Start-Process -Wait -WindowStyle Minimized -FilePath $vagrant -ArgumentList "up"  -Verb RunAs
# Copy-Item .\.vagrant\machines\ol9-server01\virtualbox\private_key $vagrantPK\ol9-server01
# Copy-Item .\.vagrant\machines\debian-client01\virtualbox\private_key $vagrantPK\debian-client01

# # Up docker stack

# ## Build Docker app-http
# $appFolder="$basePath\configs\linux\docker\images\app-http"
# If(! (Test-Path "$appFolder/images")){New-Item "$appFolder\images" -ItemType Directory -Force}#
# Copy-Item  "$basePath\images\labs.png" -Destination "$appFolder\images"
# Copy-Item "$basePath\index.html" -Destination $appFolder
# ## Up docker stack
# $docker = "$baseVagrantfile\linux\docker"
# Set-Location $docker
# Start-Process -Wait -WindowStyle Minimized -FilePath $vagrant -ArgumentList "up"  -Verb RunAs
# Copy-Item .\.vagrant\machines\ol9-server01\virtualbox\private_key $vagrantPK\ol9-server01
# Copy-Item .\.vagrant\machines\debian-client01\virtualbox\private_key $vagrantPK\debian-client01


# Up terraform aws stack
$terraform = "$baseVagrantfile\linux\terraform"
Set-Location $terraform
Start-Process -Wait -WindowStyle Minimized -FilePath $vagrant -ArgumentList "up"  -Verb RunAs
Copy-Item .\.vagrant\machines\ol9-server01\virtualbox\private_key $vagrantPK\ol9-server01
Copy-Item .\.vagrant\machines\debian-client01\virtualbox\private_key $vagrantPK\debian-client01

#Fix powershell error
$Env:VAGRANT_PREFER_SYSTEM_BIN += 0

#Remove Semafore
Remove-Item -Force $semafore
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

# Clear screen
Clear-Host

#Stop vagrant process
Get-Process -Name *vagrant* | Stop-Process -Force
Get-Process -Name *ruby* | Stop-Process -Force

# Semafore for vagrant process
$scriptPath=$PSScriptRoot
$semafore="$scriptPath\vagrant-up.silvestrini"
New-Item -ItemType File -Path $semafore -Force >$null

# SSH
$ssh_path="$( (($scriptPath | Split-Path -Parent)| Split-Path -Parent) | Split-Path -Parent)\security"
Copy-Item -Force "$env:USERPROFILE\.ssh\id_ecdsa.pub" -Destination $ssh_path

switch ($(hostname)) {
   "silvestrini" {
      # Variables
      $vagrant="E:\Apps\Vagrant\bin\vagrant.exe"
      $vagrantHome = "E:\Apps\Vagrant\vagrant.d" 
      $vagrantPK="F:\Projetos\vagrant-pk"
      $baseVagrantfile="F:\CERTIFICACAO\labs\vagrant\"
      $virtualboxFolder = "E:\Apps\VirtualBox"
      $virtualboxVMFolder = "E:\Servers\VirtualBox"

      # VirtualBox home directory.
      Start-Process -Wait -NoNewWindow -FilePath "$virtualboxFolder\VBoxManage.exe" `
      -ArgumentList  @("setproperty", "machinefolder", "$virtualboxVMFolder")
      # Vagrant home directory for downloadad boxes.
      setx VAGRANT_HOME "$vagrantHome" >$null
   }
   "silvestrini2" {      
      # Variables
      $vagrant="C:\Cloud\Vagrant\bin\vagrant.exe"
      $vagrantHome = "C:\Cloud\Vagrant\.vagrant.d" 
      $vagrantPK="C:\Cloud\Vagrant\vagrant-pk"
      $baseVagrantfile="C:\Users\marcos.silvestrini\OneDrive\Projetos\labs\Vagrant"
      $virtualboxFolder = "C:\Program Files\Oracle\VirtualBox"
      $virtualboxVMFolder = "C:\Cloud\VirtualBox"

      # VirtualBox home directory.
      Start-Process -Wait -NoNewWindow -FilePath "$virtualboxFolder\VBoxManage.exe" `
      -ArgumentList  @("setproperty", "machinefolder", "$virtualboxVMFolder")
      # Vagrant home directory for downloadad boxes.
      setx VAGRANT_HOME "$vagrantHome" >$null
   }
   Default {Write-Host "This hostname is not available for execution this script!!!";exit 1}
}

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

# Up Servers NFS
# After up vms, execute this scripts: create_local_user.ps1,create_share.ps1 for create windows share
$nfs = "$baseVagrantfile\linux\nfs"
Set-Location $nfs
Start-Process -Wait -WindowStyle Minimized -FilePath $vagrant -ArgumentList "up"  -Verb RunAs
Copy-Item .\.vagrant\machines\ol9-server01\virtualbox\private_key $vagrantPK\ol9-server01
Copy-Item .\.vagrant\machines\debian-server01\virtualbox\private_key $vagrantPK\debian-server01
Copy-Item .\.vagrant\machines\debian-client01\virtualbox\private_key $vagrantPK\debian-client01

#Fix powershell error
$Env:VAGRANT_PREFER_SYSTEM_BIN += 0

#Remove Semafore
Remove-Item -Force $semafore
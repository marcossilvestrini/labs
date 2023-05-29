# Execute script as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))  
{  
  $arguments = "& '" +$myinvocation.mycommand.definition + "'"
  Start-Process -Wait powershell -Verb runAs -WindowStyle Hidden -ArgumentList $arguments
  Break
}

code --list-extensions > vs_code_extensions_list.txt
get-content vs_code_extensions_list.txt | % { code --install-extension $_ }
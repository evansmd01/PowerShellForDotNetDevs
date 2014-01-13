#**************************************************
Write-Host ****************************************
Write-Host Web Administration Module
Write-Host ****************************************
#**************************************************

#Make sure you're running as administrator
Import-Module WebAdministration

#show all websites
Get-Website

#**************************************************
Write-Host ****************************************
Write-Host Bindings
Write-Host ****************************************
#**************************************************

Get-Website | where { $_.Name -eq 'Default Web Site' } | Get-WebBinding

New-WebBinding -Protocol http -Port 8080 -IPAddress 127.0.0.1 -Name 'Default Web Site'

Remove-WebBinding -Protocol http -Port 8080 -IPAddress 127.0.0.1 -Name 'Default Web Site'


#**************************************************
Write-Host ****************************************
Write-Host Virtual Directories
Write-Host ****************************************
#**************************************************

Get-Website | where { $_.Name -eq 'Default Web Site' } | Get-WebVirtualDirectory

New-WebVirtualDirectory -Site 'Default Web Site' -Name MyVirtualDir -Application "\" -PhysicalPath C:/Temp

Remove-WebVirtualDirectory -Site 'Default Web Site' -Name MyVirtualDir -Application "\"


#**************************************************
Write-Host ****************************************
Write-Host System.Web.Administration.ServerManager
Write-Host ****************************************
#**************************************************

Add-Type -Path C:\windows\system32\inetsrv\Microsoft.Web.Administration.dll

$manager = New-Object -TypeName Microsoft.Web.Administration.ServerManager 

$defaultSite = $manager.Sites | where { $_.Name -eq 'Default Web Site' } 

#**************************************************
Write-Host ****************************************
Write-Host Bindings
Write-Host ****************************************
#**************************************************

Write-Host $defaultSite.Bindings

#add a binding
$binding = $defaultSite.Bindings.Add("127.0.0.1:8080:", "http")

#remove a binding
$defaultSite.Bindings.Remove($binding)

#**************************************************
Write-Host ****************************************
Write-Host Virtual Directories
Write-Host ****************************************
#**************************************************

Write-Host $defaultSite.Applications["/"].VirtualDirectories

#add virtual directory
$defaultSite.Applications["/"].VirtualDirectories.Add("/MyVirtualDir", "C:/Temp")

#remove virtual directory
$defaultSite.Applications["/"].VirtualDirectories.Remove($defaultSite.Applications["/"].VirtualDirectories["/MyVirtualDir"])

#**************************************************
Write-Host ****************************************
Write-Host Commit Changes
Write-Host ****************************************
#**************************************************

#The changes are transactional (part of why its so much faster)
#don't forget to commit
$manager.CommitChanges()


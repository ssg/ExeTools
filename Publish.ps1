#Requires -Module Microsoft.PowerShell.SecretManagement

Publish-Module -Name .\ExeTools.psd1 -NuGetApiKey (Get-Secret PSGalleryAPIKey -AsPlainText)
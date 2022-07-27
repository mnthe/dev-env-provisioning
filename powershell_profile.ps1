# Set prompt
Import-Module posh-git
Import-Module oh-my-posh
oh-my-posh init powershell -c "$HOME\.oh-my-posh\themes\default.json" | Invoke-Expression

# Set kubectl auto completion
Import-Module PSKubectlCompletion  
Set-Alias k -Value kubectl  
Register-KubectlCompletion  

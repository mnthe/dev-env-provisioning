# Set prompt
Import-Module posh-git
Import-Module oh-my-posh
Set-PoshPrompt -Theme powerlevel10k_lean

# Set kubectl auto completion
Import-Module PSKubectlCompletion  
Set-Alias k -Value kubectl  
Register-KubectlCompletion  

# Set prompt
Import-Module oh-my-posh
oh-my-posh init powershell -c "https://raw.githubusercontent.com/mnthe/dev-env-provisioning/main/.oh-my-posh/themes/default.json" | Invoke-Expression

# Set kubectl auto completion
Import-Module PSKubectlCompletion  
Set-Alias k -Value kubectl  
Register-KubectlCompletion  

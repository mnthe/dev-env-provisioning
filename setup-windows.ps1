Requires -RunAsAdministrator

$ProgressPreference = 'SilentlyContinue'

choco install 1password --yes --force
choco install googlechrome --yes --force
choco install steam --yes --force
choco install slack --yes --force
choco install discord --yes --force

# Install Kakaotalk
$KAKAO_TALK = "$HOME\Downloads\KakaoTalk_Setup.exe"
Invoke-WebRequest -Uri https://app-pc.kakaocdn.net/talk/win32/KakaoTalk_Setup.exe -OutFile $KAKAO_TALK
Start-Process -Wait -FilePath $KAKAO_TALK -ArgumentList "/S"

# Install Development Tools
choco install git --yes --force
choco install gnupg --yes --force
choco install vscode --yes --force
choco install docker-desktop --yes --force
choco install visualstudio2019professional --yes --force `
    --package-parameters "--add Microsoft.VisualStudio.Workload.NetWeb --add Microsoft.VisualStudio.Workload.NetCoreTools --includeRecommended --passive --locale en-US"
choco install nodejs-lts --yes --force
choco install golang --yes --force
choco install python --yes --force
choco install aws-iam-authenticator --yes --force
choco install lens --yes --force
choco install kubernetes-cli --yes --force
choco install postman --yes --force
choco install vault --yes --force
choco install packer --yes --force
choco install terraform --yes --force
choco install microsoft-windows-terminal --yes --force

# Install Fonts
choco install firacode --yes --force
choco install firacodenf --yes --force

# Install AWS CLI2
$AWS_CLI_V2 = "$HOME\Downloads\AWSCLIV2.msi" /qn+

# Install ansible
pip3 install ansible

# Config git
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/mnthe/dev-env-provisioning/main/.gitconfig" -OutFile $env:USERPROFILE\.gitconfig

# Config Powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
Install-PackageProvider -Name NuGet -Force
Install-Module posh-git -Scope CurrentUser -Force
Install-Module oh-my-posh -Scope CurrentUser -Force
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/mnthe/dev-env-provisioning/main/powershell_profile.ps1" -OutFile $profile


# Prepare WSL2 (https://docs.microsoft.com/ko-kr/windows/wsl/install-win10)
wsl --install

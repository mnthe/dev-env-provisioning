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

# Install AWS CLI2
$AWS_CLI_V2 = "$HOME\Downloads\AWSCLIV2.msi"
Invoke-WebRequest -Uri https://awscli.amazonaws.com/AWSCLIV2.msi -OutFile $AWS_CLI_V2
msiexec /i $AWS_CLI_V2 /quiet /qn /norestart
Remove-Item $AWS_CLI_V2

# Install ansible
pip3 install ansible

# Install Windows Terminal
$WINDOWS_TERMINAL = "$HOME\Downloads\WINDOWS_TERMINAL.msixbundle"
Invoke-WebRequest -Uri "https://github.com/microsoft/terminal/releases/download/v1.9.1942.0/Microsoft.WindowsTerminal_1.9.1942.0_8wekyb3d8bbwe.msixbundle" -OutFile $WINDOWS_TERMINAL
Add-AppPackage -path $WINDOWS_TERMINAL 
Remove-Item $WINDOWS_TERMINAL

# Prepare WSL2 (https://docs.microsoft.com/ko-kr/windows/wsl/install-win10)
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

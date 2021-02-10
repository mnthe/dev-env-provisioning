$ProgressPreference = 'SilentlyContinue'

choco install 1password --yes --force
choco install googlechrome --yes --force
choco install steam --yes --force
choco install slack --yes --force
choco install office365business --yes --force
choco install discord --yes --force

# Install Line
$LINE = "$HOME\Downloads\LineInst.exe"
Invoke-WebRequest -Uri https://desktop.line-scdn.net/win/new/LineInst.exe -OutFile $LINE
Start-Process -Wait -FilePath $LINE -ArgumentList "/S"
Remove-Item $LINE

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

# Install terraform multiple versions
choco install terraform --yes --force -m --version 0.12.29
Add-Content $profile "New-Alias terraform12 C:\ProgramData\chocolatey\lib\terraform.0.12.29\tools\terraform.exe"
choco install terraform --yes --force -m --version 0.13.6
Add-Content $profile "New-Alias terraform13 C:\ProgramData\chocolatey\lib\terraform.0.13.6\tools\terraform.exe"
choco install terraform --yes --force -m --version 0.14.5
Add-Content $profile "New-Alias terraform14 C:\ProgramData\chocolatey\lib\terraform.0.14.5\tools\terraform.exe"

# Install AWS CLI2
$AWS_CLI_V2 = "$HOME\Downloads\AWSCLIV2.msi"
Invoke-WebRequest -Uri https://awscli.amazonaws.com/AWSCLIV2.msi -OutFile $AWS_CLI_V2
msiexec /i $AWS_CLI_V2 /quiet /qn /norestart
Remove-Item $AWS_CLI_V2
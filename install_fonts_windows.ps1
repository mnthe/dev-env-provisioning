if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
  $arguments = "& '" +$myinvocation.mycommand.definition + "'"
  Start-Process powershell -Verb runAs -ArgumentList $arguments
  Break
}

Install-Module -Name PSWinGlue -Force
Import-Module -Name PSWinGlue

function Download-Font {
    param(
        [string] $FontURL
    )
    $FontName = [System.Web.HttpUtility]::UrlDecode($(Split-Path $FontURL -leaf))
    Invoke-WebRequest -Uri $FontURL -OutFile $HOME\Downloads\$FontName
    Install-Font $HOME\Downloads\$FontName
    rm -force $HOME\Downloads\$FontName
}

function Download-Fonts-Zip {
    param(
        [string] $FontsZipURL
    )
    $ZipName = [System.Web.HttpUtility]::UrlDecode($(Split-Path $FontsZipURL -leaf))
    Invoke-WebRequest -Uri $FontsZipURL -OutFile $HOME\Downloads\$ZipName
    mkdir -force $HOME\Downloads\FontTmp
    Expand-Archive -Path "$HOME\Downloads\$ZipName" -DestinationPath "$HOME\Downloads\FontTmp\" -Force
    Install-Font $HOME\Downloads\FontTmp\
    Remove-Item -Recurse -Force $HOME\Downloads\FontTmp\
    rm -force $HOME\Downloads\$ZipName
}

Download-Font https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
Download-Font https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
Download-Font https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
Download-Font https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

Download-Fonts-Zip https://github.com/ryanoasis/nerd-fonts/releases/download/v1.2.0/DejaVuSansMono.zip

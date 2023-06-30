#!/bin/bash

# insert_line_only_once $line $file
function insert_line_only_once {
    grep -qxF "$1" $2 || echo "$1" >>$2
}

# install_binary $name $link $binary_name
function install_binary {
    echo "Installing $1"
    curl -sLo $1 $2
    sudo chmod +x ./$1
    sudo mv ./$1 /usr/local/bin/$1
}

# install_zipped_binary $name $link $binary_name
function install_zipped_binary {
    binary=${3:-$(echo $1)}
    echo "Installing $1"
    curl -sLo tmp.zip $2
    unzip -oq tmp.zip
    sudo chmod +x ./$binary
    sudo mv ./$binary /usr/local/bin/$1
    rm -f tmp
}

# Get flags
use_personal_settings=false
username='mnthe' # Default username
while (("$#")); do
    case "$1" in
    --username)
        shift
        if (("$#")); then
            username=$1
            shift
        else
            echo "Error: Expected a value after --username"
            exit 1
        fi
        ;;
    --use-personal-settings)
        use_personal_settings=true
        shift
        ;;
    *)
        echo "Error: Invalid option"
        exit 1
        ;;
    esac
done

# Use fastest mirror
UBUNTU_RELEASE=jammy
MIRROR_TEXT="# https://askubuntu.com/questions/37753/how-can-i-get-apt-to-use-a-mirror-close-to-me-or-choose-a-faster-mirror
deb mirror://mirrors.ubuntu.com/mirrors.txt "${UBUNTU_RELEASE}" main restricted universe multiverse
deb mirror://mirrors.ubuntu.com/mirrors.txt "${UBUNTU_RELEASE}"-updates main restricted universe multiverse
deb mirror://mirrors.ubuntu.com/mirrors.txt "${UBUNTU_RELEASE}"-backports main restricted universe multiverse
deb mirror://mirrors.ubuntu.com/mirrors.txt "${UBUNTU_RELEASE}"-security main restricted universe multiverse"

if ! grep -q "$MIRROR_TEXT" /etc/apt/sources.list; then
    echo "$MIRROR_TEXT" | cat - /etc/apt/sources.list > temp && sudo mv temp /etc/apt/sources.list
    echo "Mirror list added to the start of /etc/apt/sources.list."
else
    echo "Mirror list already exists in /etc/apt/sources.list. No changes made."
fi

# Install requirements
sudo apt update
sudo apt install -y zip unzip software-properties-common
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt update

# Install Tools
## Install git
sudo apt install -y git git-lfs

# Install vscode
if [[ $(cat /proc/version) =~ "microsoft" ]]; then
    if [[ $(command -v code) =~ "/mnt/" ]]; then
        code --version # Prevent to execute code gui
    else
        echo "VSCode not installed on Windows"
    fi
else
    curl -sLo vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
    sudo apt install -y ./vscode.deb
    rm -f vscode.deb
fi

## Install oh-my-zsh
sudo apt install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
sed -i 's/%c/%~/g' ~/.oh-my-zsh/themes/robbyrussell.zsh-theme
insert_line_only_once 'source ~/.common_profile' ~/.zshrc
### Install Plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/agkozak/zsh-z ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-z
sed -i 's/plugins=([a-z]*)/plugins=(git zsh-z zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

## Install kubectl
KUBERNETES_VERSION=v1.27.1
install_binary kubectl https://storage.googleapis.com/kubernetes-release/release/$KUBERNETES_VERSION/bin/linux/amd64/kubectl

## Install aws-cli2
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install
rm -rf ./aws

## Install Azure cli
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

## Install aws-iam-authenticator
install_binary aws-iam-authenticator https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.5.9/aws-iam-authenticator_0.5.9_linux_amd64

## Install terraform
TERRAFORM_VERSION=1.5.2
install_zipped_binary terraform https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip terraform

## Install vault
VAULT_VERSION=1.14.0
install_zipped_binary vault https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip

## Install packer
PACKER_VERSION=1.8.1
install_zipped_binary packer https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip

## Install helm
curl -fsSL -o ~/get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 &&
    chmod 700 ~/get_helm.sh &&
    ~/get_helm.sh
rm -f ~/get_helm.sh

## Install tsh
TELEPORT_VERSION=13.1.5
curl https://goteleport.com/static/install.sh | bash -s ${TELEPORT_VERSION}

# Install Languages

## Install go-lang via goenv
git clone https://github.com/syndbg/goenv.git ~/.goenv
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOROOT/bin:$GOENV_ROOT/bin:$PATH"
insert_line_only_once 'export GOENV_DISABLE_GOPATH=1' ~/.common_profile
insert_line_only_once 'export GOPATH="$HOME/workspace"' ~/.common_profile
insert_line_only_once 'export GOENV_ROOT="$HOME/.goenv"' ~/.common_profile
insert_line_only_once 'export PATH="$GOROOT/bin:$GOENV_ROOT/bin:$PATH"' ~/.common_profile
insert_line_only_once 'eval "$(goenv init -)"' ~/.common_profile
goenv install 1.18.10
goenv install 1.19.10
goenv install 1.20.5
goenv global 1.20.5

## Install Node.js via nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | zsh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
source ~/.bashrc
nvm install --lts

## Install python
sudo apt install -y python3-distutils python3-venv python3 python3-pip
insert_line_only_once 'alias python=python3' ~/.common_profile
insert_line_only_once 'alias pip=pip3' ~/.common_profile
insert_line_only_once "export PATH=\"/home/${username}/.local/bin:\$PATH\"" ~/.common_profile

# Shell Completion
kubectl completion zsh >~/.kube.zsh.completion
insert_line_only_once 'source ~/.kube.zsh.completion' ~/.zshrc

# Set personal settings
if $use_personal_settings; then
    bash -s -- --username "$username" < <(curl -s https://raw.githubusercontent.com/mnthe/dev-env-provisioning/main/setup-linux-personal-settings.sh)
fi

# Done
source ~/.common_profile
insert_line_only_once 'source ~/.common_profile' ~/.zshrc

echo "Installation Done"
echo 'Please run "chsh -s /bin/zsh"'
echo "Please restart your terminal"

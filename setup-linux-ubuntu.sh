#!/bin/bash

# insert_line_only_once $line $file
function insert_line_only_once {
    grep -qxF "$1" $2 || echo "$1" >>  $2
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

if [[ $(cat /proc/version) =~ "microsoft" ]]; then
    echo "[network]" | sudo tee /etc/wsl.conf 
    echo "generateResolvConf = false" | sudo tee -a /etc/wsl.conf
    sudo rm -Rf /etc/resolv.conf
    echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf 
    echo "nameserver 1.1.1.1" | sudo tee -a /etc/resolv.conf 
fi

# Create Workspace & Setup Profile
cd ~
mkdir -p ~/workspace/src/github.com/mnthe ~/workspace/bin
touch ~/.common_profile
insert_line_only_once 'export PATH=$PATH:$HOME/workspace/bin' ~/.common_profile
insert_line_only_once 'source ~/.common_profile' ~/.bashrc

# Install requirements
sudo apt update
sudo apt install -y zip unzip software-properties-common
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt update

# Install Tools
## Install git
sudo apt install -y git git-lfs
curl -so ~/.gitconfig https://raw.githubusercontent.com/mnthe/dev-env-provisioning/main/.gitconfig

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
### Install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's/ZSH_THEME=\"[a-z]*\"/ZSH_THEME\=\"powerlevel10k\/powerlevel10k\"/' ~/.zshrc
### Install Plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/agkozak/zsh-z ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-z
sed -i 's/plugins=([a-z]*)/plugins=(git zsh-z zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

## Install kubectl
KUBERNETES_VERSION=v1.21.11
install_binary kubectl https://storage.googleapis.com/kubernetes-release/release/$KUBERNETES_VERSION/bin/linux/amd64/kubectl

## Install aws-cli2
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install
rm -rf ./aws

## Install aws-iam-authenticator
install_binary aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.18.9/2020-11-02/bin/linux/amd64/aws-iam-authenticator

## Install terraform
TERRAFORM_VERSION=1.1.7
install_zipped_binary terraform https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip terraform

## Install vault
VAULT_VERSION=1.10.0
install_zipped_binary vault https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip

## Install packer
PACKER_VERSION=1.8.0
install_zipped_binary packer https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip

## Install helm
curl -fsSL -o ~/get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 &&
    chmod 700 ~/get_helm.sh &&
    ~/get_helm.sh
rm -f ~/get_helm.sh

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
goenv install 1.16.15
goenv install 1.17.8
goenv install 1.18.0
goenv global 1.17.8

## Install Node.js via nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | zsh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source ~/.bashrc
nvm install --lts

## Install python
sudo apt install -y python3-distutils python3-venv python3 python3-pip
insert_line_only_once 'alias python=python3' ~/.common_profile
insert_line_only_once 'alias pip=pip3' ~/.common_profile
insert_line_only_once 'export PATH="/home/mnthe/.local/bin:$PATH"' ~/.common_profile 

## Install Ansible
pip3 install ansible

## Install Keybase
curl --remote-name https://prerelease.keybase.io/keybase_amd64.deb
sudo apt install -y ./keybase_amd64.deb
rm -f ./keybase_amd64.deb
run_keybase

# Shell Completion
kubectl completion zsh > ~/.kube.zsh.completion
insert_line_only_once 'source ~/.kube.zsh.completion' ~/.zshrc

# Aliases
insert_line_only_once 'alias c=clear' ~/.common_profile
insert_line_only_once 'alias t=terraform' ~/.common_profile
insert_line_only_once 'alias k=kubectl' ~/.common_profile
insert_line_only_once 'alias apt="sudo apt-get"' ~/.common_profile

# Done
source ~/.common_profile
insert_line_only_once 'source ~/.common_profile' ~/.zshrc

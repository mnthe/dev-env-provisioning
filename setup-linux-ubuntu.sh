#!/bin/bash

# insert_line_only_once $line $file
function insert_line_only_once {
    grep -qxF "$1" $2 || echo "$1" >>  $2
}

# install_binary $name $link $binary_name
function install_binary {
    echo "Installing $1"
    curl -so $1 $2
    chmod +x ./$1
    sudo mv ./$1 /usr/local/bin/$1
}

# install_zipped_binary $name $link $binary_name
function install_zipped_binary {
    binary=${3:-$(echo $1)}
    echo "Installing $1"
    curl -so tmp $2
    unzip -oq tmp
    chmod +x ./$binary
    sudo mv ./$binary /usr/local/bin/$1
    rm -f tmp
}

NODE_VER=14.x
GOLANG_VER=1.15.8

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

## Install kubectl
install_binary kubectl https://storage.googleapis.com/kubernetes-release/release/v1.20.0/bin/linux/amd64/kubectl
### Install Krew
cd "$(mktemp -d)" &&
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz" &&
    tar zxvf krew.tar.gz &&
    KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_$(uname -m | sed -e 's/x86_64/amd64/' -e 's/arm.*$/arm/' -e 's/aarch64$/arm64/')" &&
    "$KREW" install krew &&
    cd ~
insert_line_only_once 'export PATH=$PATH:$HOME/.krew/bin' ~/.common_profile

## Install aws-cli2
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install
rm -rf ./aws

## Install aws-iam-authenticator
install_binary aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.18.9/2020-11-02/bin/linux/amd64/aws-iam-authenticator

## Install terraform
install_zipped_binary terraform14 https://releases.hashicorp.com/terraform/0.14.6/terraform_0.14.6_linux_amd64.zip terraform
install_zipped_binary terraform13 https://releases.hashicorp.com/terraform/0.13.6/terraform_0.13.6_linux_amd64.zip terraform
install_zipped_binary terraform12 https://releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_linux_amd64.zip terraform

## Install vault
install_zipped_binary vault https://releases.hashicorp.com/vault/1.6.2/vault_1.6.2_linux_amd64.zip

## Install packer
install_zipped_binary packer https://releases.hashicorp.com/packer/1.6.6/packer_1.6.6_linux_amd64.zip

# Install Languages

## Install go-lang
curl -sOL https://golang.org/dl/go$GOLANG_VER.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go$GOLANG_VER.linux-amd64.tar.gz
insert_line_only_once 'export PATH=$PATH:/usr/local/go/bin' ~/.common_profile
insert_line_only_once 'export GOPATH=$HOME/workspace' ~/.common_profile
insert_line_only_once 'export GOBIN=$HOME/workspace/bin' ~/.common_profile
source ~/.common_profile
rm -f go$GOLANG_VER.linux-amd64.tar.gz

## Install Node.js
curl -sL https://deb.nodesource.com/setup_$NODE_VER | sudo -E bash -
sudo apt-get install -y nodejs

## Install python
sudo apt install -y python3-distutils python3-venv python3 python3-pip
insert_line_only_once 'alias python=python3' ~/.common_profile
insert_line_only_once 'alias pip=pip3' ~/.common_profile

# Done
source ~/.common_profile

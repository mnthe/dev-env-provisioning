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

GOLANG_VER=1.15.7

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
sed -i 's/plugins=([a-z]*)/plugins=(git docker zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

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

## Install go-lang via goenv
git clone https://github.com/syndbg/goenv.git ~/.goenv
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOROOT/bin:$GOENV_ROOT/bin:$PATH"
insert_line_only_once 'export GOENV_DISABLE_GOPATH=1' ~/.common_profile
insert_line_only_once 'export GOPATH="$HOME/workspace"' ~/.common_profile
insert_line_only_once 'export GOENV_ROOT="$HOME/.goenv"' ~/.common_profile
insert_line_only_once 'export PATH="$GOROOT/bin:$GOENV_ROOT/bin:$PATH"' ~/.common_profile
insert_line_only_once 'eval "$(goenv init -)"' ~/.common_profile
goenv install $GOLANG_VER
goenv global $GOLANG_VER

## Install Node.js via nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | zsh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
source ~/.bashrc
nvm install --lts

## Install python
sudo apt install -y python3-distutils python3-venv python3 python3-pip
insert_line_only_once 'alias python=python3' ~/.common_profile
insert_line_only_once 'alias pip=pip3' ~/.common_profile
# TODO: Install using pyenv
# git clone https://github.com/pyenv/pyenv.git ~/.pyenv
# cd ~/.pyenv && src/configure && make -C src
# insert_line_only_once 'export PYENV_ROOT="$HOME/.pyenv"' ~/.common_profile
# insert_line_only_once 'export PATH="$PYENV_ROOT/bin:$PATH"' ~/.common_profile
# insert_line_only_once 'source ~/.pyenv_profile' ~/.common_profile
# echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' > ~/.pyenv_profile
# source ~/.pyenv_profile
# pyenv install $(pyenv install --list | grep -v - | grep -v b | tail -1)



# Shell Completion
kubectl completion zsh > ~/.kube.zsh.completion
insert_line_only_once 'source ~/.kube.zsh.completion' ~/.zshrc

# Aliases
insert_line_only_once 'alias k=kubectl' ~/.common_profile

# Done
source ~/.common_profile

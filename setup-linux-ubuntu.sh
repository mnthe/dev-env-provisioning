#!/bin/bash

NODE_VER=14.x
GOLANG_VER=1.15.8


# Create Workspace & Setup Profile
mkdir -p ~/workspace/src/github.com/mnthe ~/workspace/bin
echo "export PATH=\$PATH:\$HOME/workspace/bin" >> ~/.common_profile
echo "source ~/.common_profile" >> ~/.bashrc

# Install Tools
## Install git
sudo apt update && sudo apt install -y git git-lfs
mv .gitconfig ~/.gitconfig

## Install vscode
curl -o vscode.deb -L "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
sudo apt install ./vscode.deb
rm -f vscode.deb

## Install oh-my-zsh
sudo apt install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
sed -i 's/%c/%~/g' ~/.oh-my-zsh/themes/robbyrussell.zsh-theme
# Install Languages

## Install go-lang
curl -OL https://golang.org/dl/go$GOLANG_VER.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go$GOLANG_VER.linux-amd64.tar.gz
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.common_profile
echo "export GOPATH=\$HOME/workspace" >> ~/.common_profile
echo "export GOBIN=\$HOME/workspace/bin" >> ~/.common_profile
source ~/.common_profile
rm -f go$GOLANG_VER.linux-amd64.tar.gz

## Install Node.js
curl -sL https://deb.nodesource.com/setup_$NODE_VER | sudo -E bash -
sudo apt-get install -y nodejs


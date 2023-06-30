#!/bin/bash

# insert_line_only_once $line $file
function insert_line_only_once {
    grep -qxF "$1" $2 || echo "$1" >>$2
}

username='mnthe'  # Default username

# Process command line options
while (( "$#" )); do
  case "$1" in
    --username)
      shift
      if (( "$#" )); then
        username=$1
        shift
      else
        echo "Error: Expected a value after --username"
        exit 1
      fi
      ;;
  esac
done

# Use Google DNS servers
if [[ $(cat /proc/version) =~ "microsoft" ]]; then
    echo "[network]" | sudo tee /etc/wsl.conf 
    echo "generateResolvConf = false" | sudo tee -a /etc/wsl.conf
    sudo rm -Rf /etc/resolv.conf
    echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf 
    echo "nameserver 1.1.1.1" | sudo tee -a /etc/resolv.conf 
fi

# Create Workspace & Setup Profile
cd ~
mkdir -p ~/workspace/src/github.com/${username} ~/workspace/bin
touch ~/.common_profile
insert_line_only_once 'export PATH=$PATH:$HOME/workspace/bin' ~/.common_profile
insert_line_only_once 'source ~/.common_profile' ~/.bashrc

# Use predefined gitconfig
curl -so ~/.gitconfig https://raw.githubusercontent.com/mnthe/dev-env-provisioning/main/.gitconfig
## if username is not mnthe, delete [user] section
if [[ $username != "mnthe" ]]; then
  awk '/\[user\]/{flag=1; next} /^\[.*\]/{flag=0} !flag' ~/.gitconfig > temp && mv temp ~/.gitconfig
fi


### Install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's/ZSH_THEME=\"[a-z]*\"/ZSH_THEME\=\"powerlevel10k\/powerlevel10k\"/' ~/.zshrc
## Use predefined p10k config
curl -so ~/.p10k.zsh https://raw.githubusercontent.com/mnthe/dev-env-provisioning/main/.oh-my-zsh/.p10k.zsh
insert_line_only_once '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' ~/.zshrc

## Install Keybase
curl --remote-name https://prerelease.keybase.io/keybase_amd64.deb
sudo apt install -y ./keybase_amd64.deb
rm -f ./keybase_amd64.deb
run_keybase

# Aliases
insert_line_only_once 'alias c=clear' ~/.common_profile
insert_line_only_once 'alias t=terraform' ~/.common_profile
insert_line_only_once 'alias k=kubectl' ~/.common_profile
insert_line_only_once 'alias apt="sudo apt-get"' ~/.common_profile

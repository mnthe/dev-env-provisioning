#!/bin/bash
function insert_line_only_once {
    grep -qxF "$1" $2 || echo "$1" >> $2
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

touch ~/.common_profile

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/mnthe/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

brew install git git-lfs gnupg jq gnu-sed
git lfs install —system
alias sed=gsed
insert_line_only_once 'alias sed=gsed' ~/.common_profile
  
# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
/opt/homebrew/bin/gsed -i 's/%c/%~/g' ~/.oh-my-zsh/themes/robbyrussell.zsh-theme
insert_line_only_once 'source ~/.common_profile' ~/.zshrc

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/agkozak/zsh-z ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-z
/opt/homebrew/bin/gsed -i 's/plugins=(\([a-z\-\w]*\))/plugins=(\1 zsh-z zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc 

brew install goenv
insert_line_only_once 'export GOENV_DISABLE_GOPATH=1' ~/.common_profile
insert_line_only_once 'export GOPATH="$HOME/workspace"' ~/.common_profile
insert_line_only_once 'export GOENV_ROOT="$HOME/.goenv"' ~/.common_profile
insert_line_only_once 'export PATH="$GOROOT/bin:$GOENV_ROOT/bin:$PATH"' ~/.common_profile
insert_line_only_once 'eval "$(goenv init -)"' ~/.common_profile
goenv install 1.18.10
goenv install 1.19.10
goenv install 1.20.5
goenv global 1.20.5

brew install nvm
nvm install --lts

brew install teleport

brew install vault terraform packer 
brew install helm kubernetes-cli
kubectl completion zsh > ~/.kube.zsh.completion
insert_line_only_once 'source ~/.kube.zsh.completion' ~/.zshrc

brew install --cask 1password
brew install --cask 1password-cli
brew install --cask keybase

brew install --cask warp
brew install --cask docker # docker desktop
brew install --cask slack
brew install --cask openlens
brew install --cask notion
brew install --cask microsoft-edge
brew install --cask microsoft-outlook
brew install --cask microsoft-teams
brew install --cask visual-studio
brew install --cask visual-studio-code

brew install --cask displaylink
brew install --cask betterdisplay
brew install --cask karabiner-elements
brew install --cask scroll-reverser

curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /

brew install azure-cli

# Set personal settings
if $use_personal_settings; then
    bash -s -- --username "$username" < <(curl -s https://raw.githubusercontent.com/mnthe/dev-env-provisioning/main/setup-linux-personal-settings.sh)
fi


source ~/.common_profile
insert_line_only_once 'source ~/.common_profile' ~/.zshrc

echo "Installation Done"

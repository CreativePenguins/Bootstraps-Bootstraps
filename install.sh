#!/bin/bash

# Get root privelages
sudo -v

# Brew packages to install
PACKAGES=(
  apache-spark
  awscli
  bash
  cloc
  consul
  coreutils
  findutils
  gcc
  git
  gnu-sed
  gnupg
  hadolint
  helm
  openssh
  ipython
  kubernetes-cli
  lsd
  mas
  node
  nvm
  postgresql
  pyenv
  ruby
  sqlite
  stern
  terraform
  the_silver_searcher
  tmux
  tree
  vault
  vim
  watch
  yamllint
  zsh
)

# Brew casks to install
CASKS=(
  1password
  atom
  dbeaver-community
  docker
  firefox
  google-chrome
  insomnia
  intellij-idea-ce
  iterm2
  pycharm-ce
  rectangle
  slack
  temurin
  visual-studio-code
)

# Install developer tools
echo "Installing Dev Tools..."
xcode-select --install
echo "Press return when ready to move on..."
read -n 1 

# Install homebrew
echo "Installing homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo "Press return when ready to move on..."
read -n 1
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/hombrew/bin/brew shellenv)"


echo "Installing homebrew goodies..."
brew update
brew install ${PACKAGES[@]}
brew install --cask --appdir="~/Applications" ${CASKS[@]}
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
brew cleanup

# Install applications from App Store
echo "Installing Mac Apps..."
echo "Please log into Mac App Store to continue and press return when ready..."
read -n 1
mas install 603117688 # CCMenu
mas install 1457158844 # Take a Break - 20/20/20
mas install 1423210932 # Flow - Pomodoro
mas install 937984704 # Amphetamine
mas install 497799835 # Xcode

# Install OhMyZsh
echo "Installing OhMyZsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install ZSH plugins
echo "Installing OhMyZsh Plugins..."
# Auto Suggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# Syntax Highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Cloning Spaceship prompt for ZSH
echo "Installing Spaceship..."
git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

# Make room for code
echo "Making Code Folder..."
mkdir -p ~/Code

# Installing preferences 
echo "Installing Preferences..."
mv ~/.zshrc ~/.zshrc_backup
cp zshrc ~/.zshrc
cp vimrc ~/.vimrc
cp com.googlecode.iterm2.plist ~/Code/Preferences/com.googlecode.iterm2.plist

# Install Powerline fonts
echo "Installing Powerline Fonts..."
# clone
git clone https://github.com/powerline/fonts.git --depth=1
# install
cd fonts
./install.sh
# clean-up a bit
cd ..
rm -rf fonts

# Virtual Python Environments
echo "Installing Python Virtual Environments..."
pip3 install virtualenv
pip3 install virtualenvwrapper

echo "Setting some cool settings..."
# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Finder: don't show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool false

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Use column view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Bottom left screen corner → Start screen saver
defaults write com.apple.dock wvous-bl-corner -int 5
defaults write com.apple.dock wvous-bl-modifier -int 0

# VS Code Extentions
cat << EOF >> ~/.zshrc
# Add Visual Studio Code (code)
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
EOF

cat vscodeExtensions.txt | xargs code --install-extension --force

echo "Make sure to change your iTerm to use ~/Code/Preferences/com.googlecode.iterm2.plist"
echo "DONE!"

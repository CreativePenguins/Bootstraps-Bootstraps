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
  homebrew/dupes/openssh
  ipython
  kubernetes-cli
  mas
  node
  nvm
  postgresql
  python
  python3
  ruby
  sqlite
  stern
  terraform
  the_silver_searcher
  tmux
  tree
  vault
  watch
  yamllint
  zsh
)

# Brew casks to install
CASKS=(
  1password
  adoptopenjdk11
  atom
  dbeaver-community
  docker
  firefox
  firefox-developer-edition
  google-chrome
  google-chrome-canary
  insomnia
  intellij-idea-ce
  iterm2
  pycharm-ce
  rectangle
  slack
  visual-studio-code
)

# Install developer tools
echo "Installing Dev Tools..."
xcode-select --install

# Install homebrew
echo "Installing homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

echo "Installing homebrew goodies..."
brew tap caskroom/cask
brew update
brew install ${PACKAGES[@]}
brew install vim --override-system-vi
brew cask install --appdir="~/Applications" ${CASKS[@]}
brew cleanup

# Change default shell to ZSH
echo "Changing to zsh..."
chsh $(which zsh)

# Install applications from App Store
echo "Installing Mac Apps..."
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
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1

# Symlinking 
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

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

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
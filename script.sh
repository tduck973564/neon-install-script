#!/usr/bin/sh

echo CD into home directory
cd ~

echo Update system before continuing
sudo pkcon refresh
sudo pkcon update

echo Installation of Oh My Zsh!
sudo pkcon install -y zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"
chsh -s /usr/bin/zsh
sed -e s/robbyrussell/lukerandall/ ~/.zshrc > ~/.zshrc.tmp && mv ~/.zshrc.tmp ~/.zshrc

echo Installation of GitHub CLI and setup of Git
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install -y gh
sh -c "gh auth login"

echo "Type in your git username: "
read GITUSERNAME
echo "Type in your git email: "
read GITEMAIL

git config --global user.name $GITUSERNAME
git config --global user.email  $GITEMAIL

echo Installation of VSCode and KDevelop
sudo pkcon install -y kdevelop

sudo apt-get install -y wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt install -y apt-transport-https
sudo apt update
sudo apt install -y code

echo Installation of Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain stable --profile default -y

echo Installation of Python
sudo pkcon install -y python-is-python3 python3-pip python3-venv
pip install --upgrade pip
pip install pylint
curl -sSL https://install.python-poetry.org | python3 -

echo Installation of TypeScript and JavaScript
sudo pkcon install -y nodejs
sudo npm install -g typescript npm

echo Installation of Java
sudo pkcon install -y openjdk-17-jdk

echo Installation of Clang and CMake
sudo pkcon install -y clang-11 clang-tools-11 clangd-11 cmake

echo Installation of JetBrains
curl -fsSL https://raw.githubusercontent.com/nagygergo/jetbrains-toolbox-install/master/jetbrains-toolbox.sh | bash
jetbrains-toolbox

echo Installation of VSCode extensions
code --install-extension ms-python.python
code --install-extension GitHub.copilot
code --install-extension GitHub.copilot-labs
code --install-extension vadimcn.vscode-lldb
code --install-extension icrawl.discord-vscode
code --install-extension rust-lang.rust-analyzer
code --install-extension serayuzgur.crates
code --install-extension bungcip.better-toml
code --install-extension emilast.LogFileHighlighter
code --install-extension wakatime.vscode-wakatime
code --install-extension michelemelluso.code-beautifier
code --install-extension mrmlnc.vscode-scss
code --install-extension ritwickdey.liveserver
code --install-extension ritwickdey.live-sass
code --install-extension github.vscode-pull-request-github
code --install-extension eamodio.gitlens
code --install-extension ms-vscode.cpptools-extension-pack
code --install-extension ms-vscode.makefile-tools
code --install-extension mesonbuild.mesonbuild
code --uninstall-extension ms-vscode.cpptools
code --install-extension llvm-vs-code-extensions.vscode-clangd

echo Installation of miscellaneous useful apps
sudo pkcon install -y ffmpeg pavucontrol pulseeffects gnome-keyring
flatpak install -y com.github.tchx84.Flatseal com.discordapp.Discord

echo Log into accounts on web browser
firefox https://accounts.google.com/
firefox https://login.microsoftonline.com/
firefox https://discord.com/app
firefox https://github.com/login

echo Make some folders
mkdir ~/Repositories
mkdir ~/Coding
mkdir ~/Games

echo Install OneDrive
wget -qO - https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/xUbuntu_20.04/Release.key | sudo apt-key add -
echo 'deb https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/xUbuntu_20.04/ ./' | sudo tee /etc/apt/sources.list.d/onedrive.list
sudo apt update
sudo pkcon install -y onedrive
onedrive
systemctl --user enable onedrive
systemctl --user start onedrive

echo Download icon theme and fonts
sudo pkcon install -y papirus-icon-theme fonts-inter fonts-ibm-plex fonts-roboto fonts-firacode

echo Dotfiles
git clone https://github.com/tduck973564/dotfiles ~/.dotfiles
echo ". ~/.dotfiles/.aliases" >> ~/.zshrc

echo Add .local/bin to path
echo "export PATH=$PATH:/home/$(whoami)/.local/bin"

echo -e '\nDone!'


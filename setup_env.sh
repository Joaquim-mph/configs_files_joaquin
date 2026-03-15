#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Starting deployment of Zsh, Oh My Zsh, Kitty, and uv..."

# 1. Install System Dependencies
# Installs Zsh and the package required for the 'chsh' command on Fedora
echo "Installing Zsh and util-linux-user..."
sudo dnf install -y zsh util-linux-user

# 2. Change Default Shell
# This step may prompt you for your sudo password
echo "Changing default shell to Zsh..."
sudo chsh -s $(which zsh) $USER

# 3. Install Oh My Zsh (Unattended)
# The --unattended flag prevents the installer from changing the shell automatically 
# and stops it from launching a new zsh session that would interrupt the script
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# 4. Install Kitty Terminal Emulator
# The launch=n argument prevents Kitty from opening a window immediately after installation
echo "Installing Kitty..."
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n

# 5. Kitty Desktop Integration
echo "Integrating Kitty into the Linux desktop..."
mkdir -p ~/.local/bin ~/.local/share/applications ~/.config
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/

# Programmatically fix the placeholder paths in the desktop files
sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop

# Set Kitty as the default terminal
echo 'kitty.desktop' > ~/.config/xdg-terminals.list

# 6. Install Astral's uv package manager
echo "Installing uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh

# 7. Configure Zsh Plugins
# Replaces the default plugin array in ~/.zshrc to include 'uv'
echo "Configuring Oh My Zsh plugins..."
sed -i 's/plugins=(git)/plugins=(git uv)/g' ~/.zshrc

echo "==========================================================="
echo "Setup is complete!"
echo "IMPORTANT: You must log out of your computer and log back in (or reboot)"
echo "for the default shell change to take effect and to use Kitty natively."
echo "==========================================================="

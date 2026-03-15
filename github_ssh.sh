#!/bin/bash

set -e

echo "Configuring GitHub SSH Key..."

# The -f flag sets the path and -N "" sets an empty passphrase to keep the script automated
if [! -f ~/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519 -C "your_email@example.com" -f ~/.ssh/id_ed25519 -N ""
    echo "SSH key generated."
else
    echo "SSH key already exists. Skipping generation."
fi

# Start ssh-agent in the background and add the key
echo "Starting ssh-agent..."
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

echo "==========================================================="
echo "SSH Setup is complete!"
echo "Your new SSH public key for GitHub is:"
cat ~/.ssh/id_ed25519.pub
echo ""
echo "Please copy the key above and add it to your GitHub account settings."
echo "==========================================================="

#!/bin/bash

# HP Victus GRUB Theme Installation Script
# This script installs the Victus GRUB theme and updates the GRUB configuration

set -e

THEME_NAME="victus"
THEME_DIR="/boot/grub/themes/$THEME_NAME"
GRUB_CONFIG="/etc/default/grub"
BACKUP_CONFIG="/etc/default/grub.backup.$(date +%Y%m%d_%H%M%S)"

echo "================================================"
echo "HP Victus GRUB Theme Installation"
echo "================================================"

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "Error: This script must be run as root (use sudo)" 
   exit 1
fi

# Check if GRUB is installed
if ! command -v grub-mkconfig &> /dev/null; then
    echo "Error: GRUB is not installed on this system"
    exit 1
fi

# Check if theme directory exists in current location
if [ ! -d "themes/$THEME_NAME" ]; then
    echo "Error: Theme directory 'themes/$THEME_NAME' not found in current directory"
    echo "Please run this script from the repository root directory"
    exit 1
fi

echo "Creating theme directory: $THEME_DIR"
mkdir -p "$THEME_DIR"

echo "Copying theme files..."
cp -r "themes/$THEME_NAME"/* "$THEME_DIR/"

# Set proper permissions
chmod -R 644 "$THEME_DIR"
find "$THEME_DIR" -type d -exec chmod 755 {} \;

echo "Backing up GRUB configuration to: $BACKUP_CONFIG"
cp "$GRUB_CONFIG" "$BACKUP_CONFIG"

echo "Updating GRUB configuration..."

# Remove existing GRUB_THEME line if present
sed -i '/^GRUB_THEME=/d' "$GRUB_CONFIG"

# Add the new theme setting
echo "GRUB_THEME=$THEME_DIR/theme.txt" >> "$GRUB_CONFIG"

# Ensure proper GRUB timeout for theme visibility
if ! grep -q "^GRUB_TIMEOUT=" "$GRUB_CONFIG"; then
    echo "GRUB_TIMEOUT=10" >> "$GRUB_CONFIG"
else
    sed -i 's/^GRUB_TIMEOUT=0$/GRUB_TIMEOUT=10/' "$GRUB_CONFIG"
fi

echo "Updating GRUB bootloader configuration..."
if command -v update-grub &> /dev/null; then
    update-grub
elif command -v grub-mkconfig &> /dev/null; then
    grub-mkconfig -o /boot/grub/grub.cfg
else
    echo "Warning: Could not update GRUB configuration automatically"
    echo "Please run 'sudo update-grub' or 'sudo grub-mkconfig -o /boot/grub/grub.cfg' manually"
fi

echo ""
echo "================================================"
echo "Installation Complete!"
echo "================================================"
echo "The HP Victus GRUB theme has been installed successfully."
echo ""
echo "Theme features:"
echo "- Minimalistic design with misty forest background"
echo "- HP Victus orange (#FF4500) highlight color"
echo "- Clean Roboto font family"
echo "- Monochrome OS icons for Linux, Windows, and Recovery"
echo ""
echo "Configuration backup saved to: $BACKUP_CONFIG"
echo ""
echo "To uninstall, restore the backup:"
echo "  sudo cp $BACKUP_CONFIG $GRUB_CONFIG"
echo "  sudo update-grub"
echo ""
echo "Reboot to see the new theme in action!"
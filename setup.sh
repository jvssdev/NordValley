#!/usr/bin/env bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
FLAKE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_NAME="NordValley"

# Helper functions
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    print_error "This script should not be executed as root! Exiting..."
    exit 1
fi

# Check if using NixOS
if [[ ! "$(grep -i nixos </etc/os-release 2>/dev/null)" ]]; then
    print_error "This installation script only works on NixOS!"
    echo "Download an ISO at https://nixos.org/download/"
    exit 1
fi

# Display banner
cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                  NixOS Setup Automation                   ║
║                      Nord Valley                          ║
╚═══════════════════════════════════════════════════════════╝
EOF
echo

# Get current user
currentUser=$(whoami)
print_info "Current user: $currentUser"

# Ask for user information
echo
read -p "Enter your full name [João Víctor Santos Silva]: " fullName
fullName=${fullName:-"João Víctor Santos Silva"}

read -p "Enter your email [joao.victor.ss.dev@gmail.com]: " userEmail
userEmail=${userEmail:-"joao.victor.ss.dev@gmail.com"}

# Ask which window manager to use
echo
echo "Select window manager:"
echo "1) River (default)"
echo "2) MangoWC"
read -p "Enter choice [1]: " wm_choice
wm_choice=${wm_choice:-1}

case $wm_choice in
    1)
        WM_CONFIG="river"
        print_info "Selected: River Window Manager"
        ;;
    2)
        WM_CONFIG="mangowc"
        print_info "Selected: MangoWC Window Manager"
        ;;
    *)
        print_warning "Invalid choice, defaulting to River"
        WM_CONFIG="river"
        ;;
esac

# Update flake.nix with user information
print_info "Updating user configuration..."

# Backup original flake.nix
cp "${FLAKE_DIR}/flake.nix" "${FLAKE_DIR}/flake.nix.backup"

# Update user information in flake.nix
sed -i -e "s/userName = \".*\"/userName = \"$currentUser\"/" \
       -e "s/fullName = \".*\"/fullName = \"$fullName\"/" \
       -e "s/userEmail = \".*\"/userEmail = \"$userEmail\"/" \
    "${FLAKE_DIR}/flake.nix"

print_success "User configuration updated"

# Handle hardware configuration
print_info "Configuring hardware..."

HARDWARE_CONFIG="${FLAKE_DIR}/hosts/ashes/hardware-configuration.nix"

if [ -f "/etc/nixos/hardware-configuration.nix" ]; then
    print_info "Found existing hardware configuration"
    sudo cp "/etc/nixos/hardware-configuration.nix" "$HARDWARE_CONFIG"
    print_success "Hardware configuration copied"
else
    print_info "Generating new hardware configuration"
    sudo nixos-generate-config --show-hardware-config | sudo tee "$HARDWARE_CONFIG" >/dev/null
    print_success "Hardware configuration generated"
fi

# Clean conflicting directories
print_info "Cleaning conflicting directories..."

paths=(
    ~/.mozilla/firefox/profiles.ini
    ~/.zen/profiles.ini
    ~/.gtkrc-*
    ~/.config/gtk-*
    ~/.config/cava
    ~/.config/mimeapps.list
)

for file in "${paths[@]}"; do
    for expanded in $file; do
        if [ -e "$expanded" ] && [ ! -L "$expanded" ]; then
            print_info "Removing: $expanded"
            rm -rf "$expanded"
        fi
    done
done

print_success "Cleanup completed"

# Create necessary directories
print_info "Creating directory structure..."

mkdir -p ~/Pictures/screenshots
mkdir -p ~/Documents
mkdir -p ~/Downloads
mkdir -p ~/.config

print_success "Directories created"

# Enable Intel drivers if needed
read -p "Enable Intel graphics drivers? (y/n) [n]: " enable_intel
if [[ $enable_intel =~ ^[Yy]$ ]]; then
    print_info "Intel drivers will be enabled"
    # This will be handled by the configuration
fi

# Ask about additional features
echo
print_info "Optional features:"
read -p "Enable Docker? (y/n) [y]: " enable_docker
enable_docker=${enable_docker:-y}

read -p "Enable virtualization (libvirt/QEMU)? (y/n) [y]: " enable_virt
enable_virt=${enable_virt:-y}

read -p "Enable Syncthing? (y/n) [y]: " enable_syncthing
enable_syncthing=${enable_syncthing:-y}

# Git configuration
if [ -d "$FLAKE_DIR/.git" ]; then
    print_info "Adding changes to git..."
    cd "$FLAKE_DIR"
    git add -A
    print_success "Changes added to git"
fi

# Final confirmation
echo
echo "═══════════════════════════════════════════════════════════"
echo "Configuration Summary:"
echo "═══════════════════════════════════════════════════════════"
echo "User: $currentUser"
echo "Full Name: $fullName"
echo "Email: $userEmail"
echo "Window Manager: $WM_CONFIG"
echo "Docker: $([[ $enable_docker =~ ^[Yy]$ ]] && echo "Yes" || echo "No")"
echo "Virtualization: $([[ $enable_virt =~ ^[Yy]$ ]] && echo "Yes" || echo "No")"
echo "Syncthing: $([[ $enable_syncthing =~ ^[Yy]$ ]] && echo "Yes" || echo "No")"
echo "═══════════════════════════════════════════════════════════"
echo
read -p "Proceed with installation? (y/n) [y]: " proceed
proceed=${proceed:-y}

if [[ ! $proceed =~ ^[Yy]$ ]]; then
    print_warning "Installation cancelled"
    # Restore backup
    if [ -f "${FLAKE_DIR}/flake.nix.backup" ]; then
        mv "${FLAKE_DIR}/flake.nix.backup" "${FLAKE_DIR}/flake.nix"
    fi
    exit 0
fi

# Build and switch
echo
print_info "Building NixOS configuration..."
print_warning "This may take a while..."
echo

if sudo nixos-rebuild switch --flake "${FLAKE_DIR}#${WM_CONFIG}"; then
    echo
    print_success "═══════════════════════════════════════════════════════════"
    print_success "  Installation completed successfully!"
    print_success "═══════════════════════════════════════════════════════════"
    echo
    print_warning "Important: Please reboot your system to apply all changes"
    echo
    echo "After reboot:"
    echo "  - Your window manager will be: ${WM_CONFIG}"
    echo "  - Your home directory will be: /home/$currentUser"
    echo "  - Config location: ${FLAKE_DIR}"
    echo
    read -p "Reboot now? (y/n) [n]: " reboot_now
    if [[ $reboot_now =~ ^[Yy]$ ]]; then
        print_info "Rebooting..."
        sudo reboot
    else
        print_info "Remember to reboot manually!"
    fi
else
    echo
    print_error "═══════════════════════════════════════════════════════════"
    print_error "  Installation failed!"
    print_error "═══════════════════════════════════════════════════════════"
    echo
    print_info "Restoring backup configuration..."
    if [ -f "${FLAKE_DIR}/flake.nix.backup" ]; then
        mv "${FLAKE_DIR}/flake.nix.backup" "${FLAKE_DIR}/flake.nix"
        print_success "Backup restored"
    fi
    echo
    print_info "Check the error messages above for details"
    print_info "You can try running the installation again"
    exit 1
fi

# Cleanup backup if everything went well
rm -f "${FLAKE_DIR}/flake.nix.backup"

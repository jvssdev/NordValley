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

# Ensure no NIX_PATH interference
unset NIX_PATH
export NIX_PATH=""

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

# Function to clean Nix channels - MOVED TO POST-INSTALL
clean_nix_channels() {
    print_info "Cleaning legacy Nix channels (post-installation cleanup)..."
    
    # Get current user
    local current_user=$(whoami)
    
    # Paths to clean in installed system
    local channel_paths=(
        "/nix/var/nix/profiles/per-user/root/channels"
        "/root/.nix-defexpr/channels"
        "/root/.local/state/nix/profiles/channels"
        "/home/$current_user/.nix-defexpr/channels"
        "/home/$current_user/.local/state/nix/profiles/channels"
    )
    
    for path in "${channel_paths[@]}"; do
        if [ -e "$path" ]; then
            print_info "Removing: $path"
            if [[ "$path" == /root/* ]] || [[ "$path" == /nix/* ]]; then
                sudo rm -rf "$path" 2>/dev/null || true
            else
                rm -rf "$path" 2>/dev/null || true
            fi
        fi
    done
    
    print_success "Channel cleanup completed"
}

# Function to check internet connectivity
check_connectivity() {
    print_info "Checking internet connectivity..."
    
    local test_urls=(
        "https://cache.nixos.org"
        "https://github.com"
        "https://nixos.org"
    )
    
    local connected=false
    for url in "${test_urls[@]}"; do
        if curl -Is --connect-timeout 5 "$url" >/dev/null 2>&1; then
            connected=true
            break
        fi
    done
    
    if [ "$connected" = false ]; then
        print_error "No internet connection detected!"
        print_warning "Please check your network connection and try again"
        return 1
    fi
    
    print_success "Internet connectivity confirmed"
    return 0
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

# Check connectivity before proceeding
if ! check_connectivity; then
    exit 1
fi

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

# Always generate fresh hardware config for this machine
print_info "Generating hardware configuration for this machine..."
sudo nixos-generate-config --show-hardware-config > /tmp/hardware-configuration.nix
sudo mv /tmp/hardware-configuration.nix "$HARDWARE_CONFIG"
sudo chown $currentUser:users "$HARDWARE_CONFIG"
print_success "Hardware configuration generated and saved"

# Create .gitignore if it doesn't exist
GITIGNORE_FILE="${FLAKE_DIR}/.gitignore"
if [ ! -f "$GITIGNORE_FILE" ]; then
    print_info "Creating .gitignore..."
    cat > "$GITIGNORE_FILE" << 'GITIGNORE'
# Hardware configurations are machine-specific
hosts/*/hardware-configuration.nix

# Nix build results
result
result-*

# Backup files
*.backup
*.old

# OS files
.DS_Store
Thumbs.db
GITIGNORE
    print_success ".gitignore created"
else
    # Check if hardware config is already ignored
    if ! grep -q "hardware-configuration.nix" "$GITIGNORE_FILE"; then
        print_info "Adding hardware-configuration.nix to .gitignore..."
        echo "" >> "$GITIGNORE_FILE"
        echo "# Hardware configurations are machine-specific" >> "$GITIGNORE_FILE"
        echo "hosts/*/hardware-configuration.nix" >> "$GITIGNORE_FILE"
        print_success "Updated .gitignore"
    else
        print_info ".gitignore already configured"
    fi
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

# NOTE: Channel cleanup moved to AFTER successful installation

# Enable Intel drivers if needed
read -p "Enable Intel graphics drivers? (y/n) [n]: " enable_intel
if [[ $enable_intel =~ ^[Yy]$ ]]; then
    print_info "Intel drivers will be enabled"
    # This will be handled by the configuration
fi

# Enable experimental features temporarily if not already enabled
print_info "Ensuring Nix experimental features are enabled..."
mkdir -p ~/.config/nix
if [ ! -f ~/.config/nix/nix.conf ] || ! grep -q "experimental-features" ~/.config/nix/nix.conf; then
    cat > ~/.config/nix/nix.conf << 'NIXCONF'
experimental-features = nix-command flakes
NIXCONF
    print_success "Experimental features enabled"
else
    print_info "Experimental features already configured"
fi

# Git configuration
if [ -d "$FLAKE_DIR/.git" ]; then
    print_info "Adding changes to git..."
    cd "$FLAKE_DIR"
    git add -A
    
    # Update flake lock
    print_info "Updating flake lock file..."
    if ! nix flake update --commit-lock-file 2>/dev/null && ! nix flake lock; then
        print_error "Failed to update flake lock. Check your internet connection."
        # Restore backup
        if [ -f "${FLAKE_DIR}/flake.nix.backup" ]; then
            mv "${FLAKE_DIR}/flake.nix.backup" "${FLAKE_DIR}/flake.nix"
        fi
        exit 1
    fi
    print_success "Flake lock updated"
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
echo ""
if [[ $enable_intel =~ ^[Yy]$ ]]; then
    echo "  • Intel Graphics Drivers"
fi
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

if sudo nixos-rebuild switch --flake "${FLAKE_DIR}#${WM_CONFIG}" --option pure-eval false; then
    echo
    print_success "═══════════════════════════════════════════════════════════"
    print_success "  Installation completed successfully!"
    print_success "═══════════════════════════════════════════════════════════"
    
    # NOW clean channels after successful installation
    echo
    clean_nix_channels
    
    echo
    print_warning "Important: Please reboot your system to apply all changes"
    echo
    echo "After reboot:"
    echo "  - Your window manager will be: ${WM_CONFIG}"
    echo "  - Your home directory will be: /home/$currentUser"
    echo "  - Config location: ${FLAKE_DIR}"
    echo ""
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
    print_warning "Channels were NOT cleaned since installation failed"
    print_info "Your system should still be in a recoverable state"
    echo
    print_info "Restoring backup configuration..."
    if [ -f "${FLAKE_DIR}/flake.nix.backup" ]; then
        mv "${FLAKE_DIR}/flake.nix.backup" "${FLAKE_DIR}/flake.nix"
        print_success "Backup restored"
    fi
    echo
    print_info "Check the error messages above for details"
    print_info "Common issues:"
    print_info "  1. Network connectivity problems"
    print_info "  2. Missing dependencies in cache"
    print_info "  3. Syntax errors in configuration"
    echo
    print_info "You can try running the installation again"
    exit 1
fi

# Cleanup backup if everything went well
rm -f "${FLAKE_DIR}/flake.nix.backup"

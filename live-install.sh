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
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_info() { echo -e "${BLUE}ℹ${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }

# Function to detect RAM and set build flags
get_build_flags() {
    local total_ram_mb=$(free -m | awk '/^Mem:/{print $2}')
    local total_ram_gb=$((total_ram_mb / 1024))
    print_info "Detected RAM: ${total_ram_gb}GB (${total_ram_mb}MB)"
    if [ "$total_ram_gb" -lt 8 ]; then
        print_warning "Low RAM detected (<8GB). Using conservative build settings."
        echo "--max-jobs 1 --cores 1"
    else
        echo ""
    fi
}

# Function to clean Nix channels
clean_nix_channels() {
    print_info "Cleaning legacy Nix channels..."
    local channel_paths=(
        "/mnt/nix/var/nix/profiles/per-user/root/channels"
        "/mnt/root/.nix-defexpr/channels"
        "/mnt/root/.local/state/nix/profiles/channels"
    )
    for path in "${channel_paths[@]}"; do
        if [ -e "$path" ]; then
            print_info "Removing: $path"
            sudo rm -rf "$path" 2>/dev/null || true
        fi
    done
    print_success "Channel cleanup completed"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    print_error "This script should not be executed as root! Exiting..."
    exit 1
fi

# Check if using NixOS live
if [[ ! "$(grep -i nixos </etc/os-release 2>/dev/null)" ]]; then
    print_error "This installation script only works on NixOS!"
    exit 1
fi

# Display banner
cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║ NixOS Setup Automation ║
║ Nord Valley ║
╚═══════════════════════════════════════════════════════════╝
EOF
echo

# Prompt for disk partitioning (manual recommended)
print_warning "Have you partitioned and formatted your disk? (e.g., using fdisk, mkfs)"
print_info "If not, exit now (Ctrl+C) and do so manually."
read -p "Disk ready and mounted? (y/n): " disk_ready
if [[ ! $disk_ready =~ ^[Yy]$ ]]; then
    print_error "Please prepare disk first."
    exit 1
fi

# Ensure mounts
print_info "Mounting filesystems (assuming /dev/sda2 as root, /dev/sda1 as EFI - adapt if needed)"
sudo mount /dev/sda2 /mnt || print_error "Mount failed - check your partitions"
sudo mkdir -p /mnt/boot
sudo mount /dev/sda1 /mnt/boot || print_error "Boot mount failed"

# Generate hardware config
print_info "Generating hardware configuration for target..."
sudo nixos-generate-config --root /mnt
print_success "Hardware config generated at /mnt/etc/nixos/hardware-configuration.nix"

# Copy repo to target
sudo mkdir -p /mnt/etc/nixos
sudo cp -r "$FLAKE_DIR/." /mnt/etc/nixos/
cd /mnt/etc/nixos

# Get current user
currentUser=$(whoami)
print_info "Current user: $currentUser"

# Ask for user information
echo
read -p "Enter your full name [João Víctor Santos Silva]: " fullName
fullName=${fullName:-"João Víctor Santos Silva"}
read -p "Enter your email [joao.victor.ss.dev@gmail.com]: " userEmail
userEmail=${userEmail:-"joao.victor.ss.dev@gmail.com"}

# Ask which window manager
echo "Select window manager:"
echo "1) River (default)"
echo "2) MangoWC"
read -p "Enter choice [1]: " wm_choice
wm_choice=${wm_choice:-1}
case $wm_choice in
    1) WM_CONFIG="river"; print_info "Selected: River" ;;
    2) WM_CONFIG="mangowc"; print_info "Selected: MangoWC" ;;
    *) WM_CONFIG="river"; print_warning "Defaulting to River" ;;
esac

# Update flake.nix
print_info "Updating user configuration..."
cp flake.nix flake.nix.backup
sed -i -e "s/userName = \".*\"/userName = \"$currentUser\"/" \
       -e "s/fullName = \".*\"/fullName = \"$fullName\"/" \
       -e "s/userEmail = \".*\"/userEmail = \"$userEmail\"/" \
    flake.nix
print_success "User configuration updated"

# Handle hardware configuration
print_info "Configuring hardware..."
HARDWARE_CONFIG="hosts/ashes/hardware-configuration.nix"
sudo cp "/mnt/etc/nixos/hardware-configuration.nix" "$HARDWARE_CONFIG"
print_success "Hardware configuration copied to flake"

# Clean conflicting directories (on live, but target is mounted)
print_info "Cleaning conflicting directories..."
# ... (keep your original cleanup code)

# Create directories
# ... (keep original)

# Clean channels
clean_nix_channels

# Enable Intel drivers?
# ... (keep original)

# Enable experimental features
# ... (keep original)

# Git config
# ... (keep original, but now in /mnt/etc/nixos)

# Get build flags
BUILD_FLAGS=$(get_build_flags)

# Final confirmation
# ... (keep original summary)
read -p "Proceed with installation? (y/n) [y]: " proceed
proceed=${proceed:-y}
if [[ ! $proceed =~ ^[Yy]$ ]]; then
    mv flake.nix.backup flake.nix
    exit 0
fi

# Install (key fix: use nixos-install)
print_info "Installing NixOS configuration..."
if sudo nixos-install --root /mnt --flake .#${WM_CONFIG} $BUILD_FLAGS --option pure-eval false; then
    print_success "Installation completed!"
    read -p "Reboot now? (y/n) [n]: " reboot_now
    if [[ $reboot_now =~ ^[Yy]$ ]]; then
        sudo reboot
    fi
else
    print_error "Installation failed!"
    mv flake.nix.backup flake.nix
    exit 1
fi

rm -f flake.nix.backup

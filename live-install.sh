#!/usr/bin/env bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_info() { echo -e "${BLUE}ℹ${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    print_error "This script must be run as root in live environment"
    exit 1
fi

# Check if in live environment
if [ ! -d "/iso" ] && [ "$(findmnt -o FSTYPE -n /)" != "tmpfs" ]; then
    print_error "This script should only be run in the NixOS live environment"
    exit 1
fi

cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║           NixOS Live Environment Installer                ║
║                   Nord Valley Setup                       ║
╚═══════════════════════════════════════════════════════════╝
EOF
echo

print_warning "This script will guide you through partitioning and installing NixOS"
echo

# Get user input
read -p "Enter username: " USERNAME
read -p "Enter full name: " FULLNAME
read -p "Enter email: " EMAIL
read -s -p "Enter password for $USERNAME: " PASSWORD
echo
read -s -p "Confirm password: " PASSWORD2
echo

if [ "$PASSWORD" != "$PASSWORD2" ]; then
    print_error "Passwords do not match!"
    exit 1
fi

# Disk selection
print_info "Available disks:"
lsblk -d -o NAME,SIZE,TYPE | grep disk
echo
read -p "Enter disk to install to (e.g., nvme0n1, sda): " DISK
DISK="/dev/$DISK"

if [ ! -b "$DISK" ]; then
    print_error "Disk $DISK does not exist!"
    exit 1
fi

print_warning "This will ERASE ALL DATA on $DISK"
read -p "Are you sure? Type 'yes' to continue: " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    print_error "Installation cancelled"
    exit 1
fi

# Window manager selection
echo
echo "Select window manager:"
echo "1) River (default)"
echo "2) MangoWC"
read -p "Enter choice [1]: " WM_CHOICE
WM_CHOICE=${WM_CHOICE:-1}

case $WM_CHOICE in
    1) WM_CONFIG="river" ;;
    2) WM_CONFIG="mangowc" ;;
    *) WM_CONFIG="river" ;;
esac

print_info "Selected: $WM_CONFIG"

# Partition the disk
print_info "Partitioning disk..."

parted "$DISK" -- mklabel gpt
parted "$DISK" -- mkpart ESP fat32 1MiB 512MiB
parted "$DISK" -- set 1 esp on
parted "$DISK" -- mkpart primary 512MiB 100%

print_success "Disk partitioned"

# Determine partition names
if [[ "$DISK" == *"nvme"* ]] || [[ "$DISK" == *"mmcblk"* ]]; then
    BOOT_PART="${DISK}p1"
    ROOT_PART="${DISK}p2"
else
    BOOT_PART="${DISK}1"
    ROOT_PART="${DISK}2"
fi

# Format partitions
print_info "Formatting partitions..."

mkfs.fat -F 32 -n BOOT "$BOOT_PART"
mkfs.ext4 -L nixos "$ROOT_PART"

print_success "Partitions formatted"

# Mount partitions
print_info "Mounting partitions..."

mount "$ROOT_PART" /mnt
mkdir -p /mnt/boot
mount "$BOOT_PART" /mnt/boot

print_success "Partitions mounted"

# Generate hardware configuration
print_info "Generating hardware configuration..."

nixos-generate-config --root /mnt

# Clone repository
print_info "Cloning NordValley repository..."

mkdir -p /mnt/home/"$USERNAME"
cd /mnt/home/"$USERNAME"

if ! git clone https://github.com/joaovictor-ss/NordValley.git; then
    print_error "Failed to clone repository"
    print_info "You can manually clone it later"
fi

REPO_DIR="/mnt/home/$USERNAME/NordValley"

if [ -d "$REPO_DIR" ]; then
    # Update flake with user info
    print_info "Updating configuration..."
    
    sed -i -e "s/userName = \".*\"/userName = \"$USERNAME\"/" \
           -e "s/fullName = \".*\"/fullName = \"$FULLNAME\"/" \
           -e "s/userEmail = \".*\"/userEmail = \"$EMAIL\"/" \
        "$REPO_DIR/flake.nix"
    
    # Copy hardware configuration
    cp /mnt/etc/nixos/hardware-configuration.nix "$REPO_DIR/hosts/ashes/"
    
    print_success "Configuration updated"
    
    # Install NixOS
    print_info "Installing NixOS..."
    print_warning "This will take a while..."
    
    if nixos-install --flake "$REPO_DIR#$WM_CONFIG" --root /mnt; then
        # Set user password
        print_info "Setting user password..."
        echo "$USERNAME:$PASSWORD" | nixos-enter --root /mnt -- chpasswd
        
        # Set ownership
        chown -R 1000:100 /mnt/home/"$USERNAME"
        
        print_success "═══════════════════════════════════════════════════════════"
        print_success "  Installation completed successfully!"
        print_success "═══════════════════════════════════════════════════════════"
        echo
        echo "Installation details:"
        echo "  User: $USERNAME"
        echo "  Window Manager: $WM_CONFIG"
        echo "  Boot partition: $BOOT_PART"
        echo "  Root partition: $ROOT_PART"
        echo
        print_warning "Please unmount and reboot:"
        echo "  umount -R /mnt"
        echo "  reboot"
    else
        print_error "Installation failed!"
        exit 1
    fi
else
    print_error "Repository not found. Manual installation required."
    print_info "After reboot, run the setup.sh script"
fi

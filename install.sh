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

# Ensure no NIX_PATH interference
unset NIX_PATH
export NIX_PATH=""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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
            print_success "Connected to: $url"
            break
        fi
    done
    
    if [ "$connected" = false ]; then
        print_error "No internet connection detected!"
        print_warning "Please check your network connection and try again"
        print_info "Tested URLs:"
        for url in "${test_urls[@]}"; do
            echo "  - $url"
        done
        return 1
    fi
    
    print_success "Internet connectivity confirmed"
    return 0
}

# Display banner
cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                  NixOS Installation Script                ║
║                      Nord Valley                          ║
╚═══════════════════════════════════════════════════════════╝
EOF
echo

# Check internet connectivity first
if ! check_connectivity; then
    echo
    print_error "Cannot proceed without internet connection"
    exit 1
fi

echo

# Check if running in live environment
if [ -d "/iso" ] || [ "$(findmnt -o FSTYPE -n /)" = "tmpfs" ]; then
    print_warning "Detected NixOS live environment"
    echo
    print_info "Please install NixOS first using the official installer:"
    print_info "  1. Use the graphical installer (Calamares) or manual installation"
    print_info "  2. Reboot into your installed NixOS system"
    print_info "  3. Then run this script"
    echo
    print_info "For manual installation, see: https://nixos.org/manual/nixos/stable/#sec-installation"
    exit 1
fi

# Check if running on NixOS
if [[ ! "$(grep -i nixos </etc/os-release 2>/dev/null)" ]]; then
    print_error "This script only works on NixOS!"
    echo
    print_info "Please install NixOS first:"
    print_info "  1. Download ISO: https://nixos.org/download/"
    print_info "  2. Boot and install using the graphical installer"
    print_info "  3. Reboot into your new NixOS system"
    print_info "  4. Then run this script"
    exit 1
fi

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    print_error "This script should not be executed as root!"
    print_info "Run it as your regular user"
    exit 1
fi

# Running in installed system
print_info "Detected installed NixOS system"
print_info "Starting setup wizard..."
echo

if [ ! -f "$SCRIPT_DIR/setup.sh" ]; then
    print_error "setup.sh not found!"
    exit 1
fi

bash "$SCRIPT_DIR/setup.sh"
exit $?

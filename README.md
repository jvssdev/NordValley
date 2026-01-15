<p align="center"><img src="https://i.imgur.com/X5zKxvp.png" width=150px></p>

# NordValley NixOS Installation Guide

<!--toc:start-->

- [NordValley NixOS Installation Guide](#nordvalley-nixos-installation-guide)
  - [Prerequisites](#prerequisites)
  - [Quick Installation](#quick-installation)
    - [Option 1: Automatic Installation (Recommended)](#option-1-automatic-installation-recommended)
  - [Post-installation](#post-installation)
    - [1. Configure the system](#1-configure-the-system)
    - [2. Verify everything is working](#2-verify-everything-is-working)
  - [Directory Structure](#directory-structure)
    - [Update the system](#update-the-system)
  - [Main Keybindings](#main-keybindings)
    - [River](#river)
  - [Additional Resources](#additional-resources)
  - [License](#license)
    - [Cleanup storage](#cleanup-storage)

<!--toc:end-->

Complete guide for installing and configuring NixOS with River or MangoWC window
managers.

## Prerequisites

- NixOS ISO (minimal or graphical)
- Internet connection
- Bootable USB drive with NixOS
- Basic Linux terminal knowledge

## Quick Installation

### Option 1: Automatic Installation (Recommended)

1. **After a minimal NixOS installation, install git via nix-shell**

```bash
nix-shell -p git
```

- **Configure network** (if needed):

```bash
# For WiFi
sudo systemctl start wpa_supplicant
wpa_cli

# For Ethernet (usually automatic)
```

2. **Clone the repository**:

```bash
# Temporarily in live environment
git clone https://github.com/jvssdev/NordValley.git
cd NordValley
```

3. **Run the installer**:

```bash
chmod +x install.sh
./install.sh
```

The script will:

- Request user information
- Install the complete system
- Configure everything automatically

## Post-installation

After rebooting into the installed system:

### 1. Configure the system

```bash
cd ~/NordValley
./install.sh
```

Or manually:

```bash
# For River
sudo nixos-rebuild switch --flake .#river

# For MangoWC
sudo nixos-rebuild switch --flake .#mangowc
```

### 2. Verify everything is working

```bash
# Test the editor
nvim

# Test the terminal
ghostty

# Check services
systemctl status
```

## Directory Structure

After installation:

````
~/NordValley/               # Main configuration
  ├── home/            # Configuration files
  ├── hosts/               # Per-host configurations
  ├── modules/             # NixOS modules
  └── flake.nix           # Entry point

## Customization

### Change Window Manager

```bash
# Rebuild with another WM
sudo nixos-rebuild switch --flake ~/NordValley#mangowc
````

### Update the system

```bash
cd ~/NordValley
nix flake update
sudo nixos-rebuild switch --flake .#river
```

## Main Keybindings

### River

- `Super + T`: Open terminal
- `Super + A`: Launcher (Fuzzel)
- `Super + Q`: Close window
- `Super + X`: Power menu

## Additional Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [River Documentation](https://github.com/riverwm/river/wiki)
- [Helix Documentation](https://docs.helix-editor.com/)

## License

This project is under the MIT license.

---

#### Cleanup storage

Delete stale paths: `nix-collect-garbage`

Delete stale paths and generations older than x days:
`nix-collect-garbage --delete-older-than 30d`
